{colors}: {
  lib,
  pkgs,
  ...
}: let
  renderedColors = colors: lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}:${value}") colors);
in {
  programs.fzf.package = pkgs.fzf.overrideAttrs (prev: {
    nativeBuildInputs =
      prev.nativeBuildInputs
      ++ [
        pkgs.makeWrapper
      ];

    postFixup = ''
      wrapProgram "$out/bin/fzf" \
        --add-flags "--color ${renderedColors colors}"
    '';
  });
}
