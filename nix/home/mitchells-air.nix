{...} @ args: let
  myLib = import ../lib.nix args;
in {
  services.syncthing = {
    settings = {
      folders = let
        work = ["mitchells-work-adobe"];
        macs = ["mitchells-mini"];
        linux = ["nublar"];

        all = work ++ macs ++ linux;
      in
        myLib.fromHome {
          "/shared/notes".devices = all;
          "/shared/dash".devices = macs ++ work;
          "/shared/alfred".devices = macs ++ work;
          "/shared/streamdeck".devices = macs ++ work;
        };
    };
  };
}
