{
  pkgs,
  age-secrets,
  ...
}: let
  aws-profile = "dag-default";
  dotnet-root = "${pkgs.dotnetCorePackages.dotnet_8.sdk}/share/dotnet/";
in
  with pkgs;
    writeShellApplication {
      name = "dk-aws";
      runtimeInputs = [
        argc
        awscli2
        dotnetCorePackages.dotnet_8.sdk
        jq
      ];
      text = ''
        # @describe A tool to fetch and store your AWS credentials
        # @meta require-tools aws,jq,dotnet
        # @meta author Mitchell Hanberg m.hanberg@draftkings.com
        # @meta version 1.0.0

        # @cmd Install aws-cia
        function aws-cia:install() {
          export DOTNET_ROOT="${dotnet-root}"

          dotnet tool install -g draftkings.cia --no-cache --add-source https://artifactory.build.dkinternal.com/artifactory/api/nuget/dknugetvirtual
        }

        # @cmd Update aws-cia
        function aws-cia:update() {
          export DOTNET_ROOT="${dotnet-root}"

          dotnet tool update -g draftkings.cia --no-cache --add-source https://artifactory.build.dkinternal.com/artifactory/api/nuget/dknugetvirtual
        }

        # @cmd Login with aws-cia
        function aws-cia:login() {
          export PATH="$PATH:$HOME/.dotnet/tools"
          export AWS_PROFILE="${aws-profile}"
          export DOTNET_ROOT="${dotnet-root}"

          aws-cia login
        }

        # @cmd Change roles and export creds as env vars
        function set-vars() {
          local arn
          local name
          unset AWS_ACCESS_KEY_ID
          unset AWS_SECRET_ACCESS_KEY
          unset AWS_SESSION_TOKEN

          arn=$(cat "${age-secrets.secrets.aws-role-arn.path}")
          name=$(cat "${age-secrets.secrets.aws-role-session-name.path}")
          creds="$(AWS_PROFILE=${aws-profile} aws sts assume-role --role-arn "$arn" --role-session-name "$name")"
          access_key_id=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
          secret_access_key=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
          session_token=$(echo "$creds" | jq -r .Credentials.SessionToken)

          echo "
        export AWS_ACCESS_KEY_ID='$access_key_id'
        export AWS_SECRET_ACCESS_KEY='$secret_access_key'
        export AWS_SESSION_TOKEN='$session_token'
        "
        }

        eval "$(argc --argc-eval "$0" "$@")"
      '';
    }
