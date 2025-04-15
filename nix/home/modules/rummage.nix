{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.rummage;

  yamlFormat = pkgs.formats.yaml {};
in {
  options.programs.rummage = {
    enable = lib.mkEnableOption "rummage - project finder";

    # package = lib.mkPackageOption pkgs "rummage" {nullable = true;};

    settings = lib.mkOption {
      type = yamlFormat.type;
      default = {};
      defaultText = lib.literalExpression "{ }";
      example =
        lib.literalExpression ''
        '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/rummage/rummage.yaml`.
      '';
    };
  };

  config = mkIf cfg.enable {
    # home.packages = mkIf (cfg.package != null) [cfg.package];

    xdg.configFile."rummage/rummage.yaml" =
      mkIf (cfg.settings != {})
      {
        source = yamlFormat.generate "rummage-config" cfg.settings;
      };
  };
}
