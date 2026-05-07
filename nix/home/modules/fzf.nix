{
  pkgs,
  config,
  ...
}:
{
  programs.fzf.package = pkgs.symlinkJoin {
    name = "fzf";
    version = pkgs.fzf.version;
    paths = [ pkgs.fzf ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/fzf" \
        --add-flags '--color "$(cat ${config.home.file.".fzf-colors".source})"'
    '';
    meta.mainProgram = "fzf";
  };
}
