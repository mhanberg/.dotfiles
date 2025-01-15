# nodepackages.nix
{pkgs, ...}: {
  home.packages = let
    gh-actions-language-server = pkgs.buildNpmPackage {
      name = "gh-actions-language-server";
      version = "0.0.3";
      nativeBuildInputs = [pkgs.bun];

      src = pkgs.fetchFromGitHub {
        owner = "lttb";
        repo = "gh-actions-language-server";
        rev = "5299d09d1513bb78fea04ac8207ba3367167125c";
        hash = "sha256-R6iZetsVOfyQP53Y/5zLKfmnQmFZSQYYRTP4v9zINog=";
      };
      postPatch = ''
        cp ${./package-lock.json} package-lock.json
      '';

      npmBuildScript = "build:node";

      npmDepsHash = "sha256-K+VjFjZhWwArZaYbx0clToV7+QWqAOZ8WcAQOnku0b8=";
    };
  in [gh-actions-language-server];
}
