{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.link-apps;

  createMacOSAlias = (
    (builtins.toString (
      pkgs.callPackage
        ({ stdenv, lib }:

          stdenv.mkDerivation rec {
            name = "create-macos-alias";

            unpackPhase = "true"; # nothing to unpack

            src = ./create-macos-alias.swift;

            dontConfigure = true;

            buildInputs = [ ];

            dontBuild = true;

            installPhase = ''
              install -D -m755 $src $out/bin/create-macos-alias
            '';

            meta = with lib; {
              license = licenses.mit;
              platforms = platforms.darwin;
              maintainers = with maintainers; [ landakram ];
            };
          }
        ) { }
    )) + "/bin/create-macos-alias"
  );
in
{
  options = {
    services.link-apps = {
      enable = mkEnableOption "create aliases (not symlinks) for macOS Apps at activation time";

      userName = mkOption {
        type = types.str;
      };

      userHome = mkOption {
        type = types.path;
      };

      dest = mkOption {
        type = types.path;
        default = "${cfg.userHome}/Applications/Nix";
        description = "Destination where nix-compiled Apps will be aliased.";
      };
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.postActivation.text = ''
      echo "Aliasing Apps to ${cfg.dest}"
      mkdir -p ${cfg.dest}
      chown ${cfg.userName} ${cfg.dest}
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r f; do
        src="$(/usr/bin/stat -f%Y "$f")"
        appname="$(basename "$src")"
        dest=${cfg.dest}/$appname
        [ -f "$dest" ] && rm "$dest"
        ${createMacOSAlias} "''${src}" "''${dest}"
      done
    '';
  };
}
