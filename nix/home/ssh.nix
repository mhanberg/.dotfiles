{ ... }: {
  programs.ssh = {
    settings = {
      "motch-ds-423" = {
        HostName = "motch-ds-423";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
      sorna.ForwardAgent = true;
      ingen.ForwardAgent = true;
      ray.ForwardAgent = true;
      nedry.ForwardAgent = true;
      hammond.ForwardAgent = true;
    };
  };
}
