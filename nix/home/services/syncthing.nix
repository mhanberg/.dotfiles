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
        "mitchells-mini.localdomain" = {
          id = "2CXIKWW-SIGA7OI-HNNQZHT-QKQOYCK-2R54KF4-Z5DMG6R-MWALLDI-DTRLHAD";
          name = "mitchells-mini";
          autoAcceptFolders = true;
        };
        "mitchells-mini.local" = {
          id = "KHWIZFK-Z3RTI2H-QINY5TP-SBITUWH-7FL3IAI-4LSKT7M-VJ44WDM-VHJQAAI";
          name = "mitchells-air";
          autoAcceptFolders = true;
        };
        nublar = {
          id = "UKBJHDO-YOFWJCX-UMXTEOS-ZBFBDNS-KXVIACN-L2ULD2N-PEJUSSA-E2VI7AM";
          autoAcceptFolders = true;
        };
        "m.hanberg-GQJNV7J4QY" = {
          id = "U5VHTUT-HCCK5RV-VIMOTAE-OEK55W2-XA74TGH-RIVVQ6B-OOJKUBG-A2KPFQG";
          name = "mitchells-work";
          autoAcceptFolders = true;
        };
      };
      folders = myLib.fromHome {
        "/shared/notes" = {
          id = "notes";
        };
      };
    };
  };
}
