{ ... }: {
  programs.ssh = {
    settings = {
      nublar = {
        HostNmae = "nublar";
        User = "mitchell";
        ForwardAgent = true;
        RequestTTY = "yes";
        LogLevel = "Quiet";

        LocalForward = [
          {
            bind.port = 4999;
            host.address = "127.0.0.1";
            host.port = 4999;
          }
          {
            bind.port = 8000;
            host.address = "127.0.0.1";
            host.port = 8000;
          }
        ];
      };
    };
  };
}
