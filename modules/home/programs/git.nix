_: {
  flake.homeModules.git = _: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "vitokalcvf";
          email = "vitorlcvf@gmail.com";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
  };
}
