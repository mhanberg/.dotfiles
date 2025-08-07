{pkgs, ...}: {
  home.packages = let
    version = "0.9.0";
    scadformat = pkgs.buildGoModule {
      name = "scadformat";
      version = version;

      nativeBuildInputs = with pkgs; [
        antlr4
        git
      ];

      src = pkgs.fetchFromGitHub {
        owner = "hugheaves";
        repo = "scadformat";
        rev = "8fb4c4c2d644dc4b9f76f03dd58791a5bcc43b7b";
        hash = "sha256-X8STNxywwu3AirR0yrVGaduIU/P9ryJoLJXeBp64qJs=";
      };

      subPackages = [
        "cmd/scadformat.go"
      ];

      vendorHash = "sha256-HOjfKFDG4otwu5TGXNtQCBQ7PURtPoeN8M8+uVHn5+4=";

      postPatch = ''
        substituteInPlace cmd/scadformat.go \
            --replace-fail 'git describe > version.txt' 'echo '${version}' > version.txt'
      '';

      preBuild = ''
        go generate ./...
      '';

      meta.mainProgram = "scadformat";
    };
  in [scadformat];
}
