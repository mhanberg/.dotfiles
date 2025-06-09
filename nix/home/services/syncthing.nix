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
        nublar = {
          id = "TITLNRM-IXYBGRC-5LXSH3T-AIMZAK5-JP3GNLD-BH66LFN-RV55GHJ-XE5ZGQM";
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
