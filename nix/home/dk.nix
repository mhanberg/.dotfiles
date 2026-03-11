{dk, ...}: {...} @ args: let
  myLib = import ../lib.nix args;
in {
  imports = [
    ./themes/rose-pine-moon.nix
    ./services/syncthing.nix
    (import dk.homeManagerModules.default {inherit myLib;})
  ];

  age.secrets = {
    aws-role-arn.file = ./dk/secrets/aws-role-arn.age;
    aws-role-session-name.file = ./dk/secrets/aws-role-session-name.age;
  };
}
