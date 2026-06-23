_: {
  flake.homeModules.tmux = _: {
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;
    };
  };
}
