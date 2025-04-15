{...} @ args: let
  myLib = import ../../lib.nix args;
in {
  services.syncthing = {
    enable = true;
    settings = {
      options = {
        globalAnnounceServers = ["https://syncthing-discovery.motch.systems"];
      };
      folders = myLib.fromHome {
        "/shared/notes" = {
          id = "notes";
        };
      };
    };
  };
}
