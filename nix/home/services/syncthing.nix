{...} @ args: let
  myLib = import ../../lib.nix args;
in {
  services.syncthing = {
    enable = true;
    settings = {
      options = {
        globalAnnounceServers = ["https://syncthing-discovery.motch.systems"];
        urAccepted = -1;
      };
      devices = {
        "mitchells-mini" = {
          id = "2CXIKWW-SIGA7OI-HNNQZHT-QKQOYCK-2R54KF4-Z5DMG6R-MWALLDI-DTRLHAD";
          autoAcceptFolders = true;
        };
        "mitchells-air" = {
          id = "KHWIZFK-Z3RTI2H-QINY5TP-SBITUWH-7FL3IAI-4LSKT7M-VJ44WDM-VHJQAAI";
          autoAcceptFolders = true;
        };
        nublar = {
          id = "UKBJHDO-YOFWJCX-UMXTEOS-ZBFBDNS-KXVIACN-L2ULD2N-PEJUSSA-E2VI7AM";
          autoAcceptFolders = true;
        };
        "mitchells-work-adobe" = {
          id = "5ANLBWH-TOOHZWK-ELC47G3-33PTHZ3-EUUQ7WP-F7UU5JZ-J7GUCSN-5FM53QZ";
          autoAcceptFolders = true;
        };
      };
      folders = myLib.fromHome {
        "/shared/notes".id = "notes";
        "/shared/dash".id = "dash";
        "/shared/alfred".id = "alfred";
      };
    };
  };
}
