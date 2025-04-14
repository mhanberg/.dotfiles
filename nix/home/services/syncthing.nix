{config, ...}: {
  services.syncthing = {
    enable = true;
    settings = {
      options = {
        globalAnnounceServers = ["https://syncthing-discovery.motch.systems"];
      };
      folders = {
        "${config.home.homeDirectory}/shared/notes" = {
          id = "notes";
        };
      };
    };
  };
}
