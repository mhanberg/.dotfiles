#!/usr/bin/env elixir

# Written with the help of OpenCode 1.2.20 and Claude Opus 4.6

defmodule UpdateActions do
  @moduledoc """
  Searches GitHub Actions workflow files and finds actions that are not pinned
  to the fully expanded latest released version's SHA with a version comment,
  then offers to update them.

  Usage:
    bin/update-actions [--dry-run] [--no-color]

  Flags:
    --dry-run   Print changes that would be made without prompting or modifying files
    --no-color  Disable colored output
  """

  # Matches lines like: `uses: owner/repo@ref` with optional version comment
  # Captures: leading whitespace + "uses: ", owner/repo, ref, optional comment
  @uses_regex ~r/^(?<prefix>\s*-?\s*uses:\s*)(?<action>[a-zA-Z0-9\-_.]+\/[a-zA-Z0-9\-_.]+)@(?<ref>[^\s#]+)(?:\s*#\s*(?<comment>.*))?$/

  # SHA pattern: exactly 40 hex characters
  @sha_regex ~r/^[0-9a-f]{40}$/

  def main(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        strict: [dry_run: :boolean, color: :boolean],
        aliases: []
      )

    dry_run = Keyword.get(opts, :dry_run, false)
    color = Keyword.get(opts, :color, true)

    if dry_run do
      IO.puts(IO.ANSI.format([:cyan, "=== DRY RUN MODE ==="], color))
      IO.puts("")
    end

    workflow_files = find_workflow_files()

    IO.puts("Found #{length(workflow_files)} workflow file(s)")
    IO.puts("")

    {results, _latest_releases} =
      workflow_files
      |> Enum.flat_map(fn file -> find_actions_in_file(file) end)
      |> Enum.reduce({%{updates: 0, skipped: 0, up_to_date: 0}, %{}}, fn action,
                                                                         {acc, latest_releases} ->
        process_action(action, latest_releases, dry_run, color, acc)
      end)

    IO.puts("")
    IO.puts(IO.ANSI.format([:bright, "=== Summary ==="], color))
    IO.puts("  Updated:    #{results.updates}")
    IO.puts("  Skipped:    #{results.skipped}")
    IO.puts("  Up to date: #{results.up_to_date}")
  end

  defp find_workflow_files do
    Path.wildcard(".github/workflows/*.{yml,yaml}")
    |> Enum.sort()
  end

  defp find_actions_in_file(file) do
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index(1)
    |> Enum.filter(fn {line, _line_no} ->
      String.contains?(line, "uses:") and Regex.match?(@uses_regex, String.trim_trailing(line))
    end)
    |> Enum.map(fn {line, line_no} ->
      captures = Regex.named_captures(@uses_regex, String.trim_trailing(line))

      %{
        file: file,
        line_no: line_no,
        full_line: line,
        action: captures["action"],
        ref: captures["ref"],
        comment: captures["comment"] || "",
        prefix: captures["prefix"]
      }
    end)

    # Note: reusable workflow references (e.g., org/repo/.github/workflows/foo.yml@ref)
    # are already excluded by the regex which only matches owner/repo@ref format
  end

  defp forcibly_pinned?(comment) do
    comment != "" and String.contains?(String.downcase(comment), "pin")
  end

  defp process_action(action, latest_releases, dry_run, color, acc) do
    %{file: file, line_no: line_no, action: action_name, ref: ref, comment: comment} = action

    comment_suffix = if(comment != "", do: " # #{comment}", else: "")

    IO.puts(
      IO.ANSI.format(
        [:bright, "#{file}:#{line_no}", :reset, " - #{action_name}@#{ref}#{comment_suffix}"],
        color
      )
    )

    if forcibly_pinned?(comment) do
      IO.puts(IO.ANSI.format([:cyan, "  ⊘ Forcibly pinned — will not be updated"], color))
      IO.puts("")
      {%{acc | skipped: acc.skipped + 1}, latest_releases}
    else
      {result, latest_releases} = fetch_latest(action_name, latest_releases)

      case result do
        {:ok, {latest_tag, latest_sha}} ->
          cond do
            is_pinned_to_latest?(ref, comment, latest_sha, latest_tag) ->
              IO.puts(IO.ANSI.format([:green, "  ✓ Up to date (#{latest_tag})"], color))
              IO.puts("")
              {%{acc | up_to_date: acc.up_to_date + 1}, latest_releases}

            true ->
              current_version = extract_current_version(ref, comment)

              IO.puts(
                IO.ANSI.format(
                  [:yellow, "  → Update available: #{current_version} → #{latest_tag}"],
                  color
                )
              )

              old_uses = build_uses_string(action_name, ref, comment)
              new_uses = "#{action_name}@#{latest_sha} # #{latest_tag}"

              show_diff(action.prefix, old_uses, new_uses, color)

              if dry_run do
                IO.puts(IO.ANSI.format([:cyan, "  (dry run — no changes made)"], color))
                IO.puts("")
                {%{acc | updates: acc.updates + 1}, latest_releases}
              else
                if prompt_user() do
                  apply_update(file, action.line_no, action.prefix, new_uses)
                  IO.puts(IO.ANSI.format([:green, "  ✓ Updated"], color))
                  IO.puts("")
                  {%{acc | updates: acc.updates + 1}, latest_releases}
                else
                  IO.puts(IO.ANSI.format([:red, "  ✗ Skipped"], color))
                  IO.puts("")
                  {%{acc | skipped: acc.skipped + 1}, latest_releases}
                end
              end
          end

        {:error, reason} ->
          IO.puts(IO.ANSI.format([:red, "  ✗ Error: #{reason}"], color))
          IO.puts("")
          {%{acc | skipped: acc.skipped + 1}, latest_releases}
      end
    end
  end

  defp is_pinned_to_latest?(ref, comment, latest_sha, latest_tag) do
    sha_matches = ref == latest_sha
    comment_trimmed = String.trim(comment)
    comment_matches = comment_trimmed == latest_tag
    sha_matches and comment_matches
  end

  defp extract_current_version(ref, comment) do
    comment_trimmed = String.trim(comment)

    cond do
      comment_trimmed != "" -> comment_trimmed
      Regex.match?(@sha_regex, ref) -> String.slice(ref, 0, 7)
      true -> ref
    end
  end

  defp build_uses_string(action_name, ref, comment) do
    comment_trimmed = String.trim(comment)

    if comment_trimmed != "" do
      "#{action_name}@#{ref} # #{comment_trimmed}"
    else
      "#{action_name}@#{ref}"
    end
  end

  defp show_diff(prefix, old_uses, new_uses, color) do
    IO.puts("")
    IO.puts(IO.ANSI.format([:red, "  - #{prefix}#{old_uses}"], color))
    IO.puts(IO.ANSI.format([:green, "  + #{prefix}#{new_uses}"], color))
    IO.puts("")
  end

  defp prompt_user do
    response =
      IO.gets("  Apply this update? [y/N] ")
      |> String.trim()
      |> String.downcase()

    response in ["y", "yes"]
  end

  defp apply_update(file, line_no, prefix, new_uses) do
    new_line = String.trim_trailing(prefix) <> " " <> new_uses

    lines = file |> File.read!() |> String.split("\n")

    new_lines =
      lines
      |> Enum.with_index(1)
      |> Enum.map(fn {line, idx} ->
        if idx == line_no, do: new_line, else: line
      end)

    File.write!(file, Enum.join(new_lines, "\n"))
  end

  defp fetch_latest(action_name, latest_releases) do
    case Map.fetch(latest_releases, action_name) do
      {:ok, result} ->
        {result, latest_releases}

      :error ->
        result = do_fetch_latest(action_name)
        {result, Map.put(latest_releases, action_name, result)}
    end
  end

  defp do_fetch_latest(action_name) do
    IO.write("  Fetching latest release for #{action_name}... ")

    case gh_api("repos/#{action_name}/tags", ".[].name") do
      {:ok, tags} ->
        {tag, _} =
          tags
          |> String.trim()
          |> String.split("\n")
          |> Enum.flat_map(fn tag ->
            if String.match?(tag, ~r/^v\d+$/) do
              tag <> ".0.0"
            else
              tag
            end
            |> String.replace_prefix("v", "")
            |> Version.parse()
            |> case do
              {:ok, version} -> [{tag, version}]
              :error -> []
            end
          end)
          |> Enum.sort_by(fn {_, version} -> version end, {:desc, Version})
          |> List.first()

        case resolve_tag_to_commit_sha(action_name, tag) do
          {:ok, sha} -> {:ok, {tag, sha}}
          error -> error
        end

      {:error, _} = error ->
        IO.puts("failed")
        error
    end
  end

  defp resolve_tag_to_commit_sha(action_name, tag) do
    case gh_api("repos/#{action_name}/git/ref/tags/#{tag}", ".object.type + \" \" + .object.sha") do
      {:ok, output} ->
        [type, sha] = output |> String.trim() |> String.split(" ", parts: 2)

        case type do
          # Lightweight tag: ref points directly to the commit
          "commit" -> {:ok, sha}
          # Annotated tag: ref points to a tag object, dereference to get the commit
          "tag" -> dereference_annotated_tag(action_name, sha)
          other -> {:error, "unexpected git object type: #{other}"}
        end

      {:error, _} = error ->
        error
    end
  end

  defp dereference_annotated_tag(action_name, tag_object_sha) do
    case gh_api(
           "repos/#{action_name}/git/tags/#{tag_object_sha}",
           ".object.type + \" \" + .object.sha"
         ) do
      {:ok, output} ->
        [type, sha] = output |> String.trim() |> String.split(" ", parts: 2)

        case type do
          "commit" -> {:ok, sha}
          # Nested annotated tags (rare, but possible)
          "tag" -> dereference_annotated_tag(action_name, sha)
          other -> {:error, "unexpected git object type: #{other}"}
        end

      {:error, _} = error ->
        error
    end
  end

  defp gh_api(endpoint, jq_filter) do
    case System.cmd("gh", ["api", endpoint, "--jq", jq_filter], stderr_to_stdout: true) do
      {output, 0} -> {:ok, output}
      {output, _} -> {:error, String.trim(output)}
    end
  end
end

UpdateActions.main(System.argv())
