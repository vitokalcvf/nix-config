_: {
  flake.homeModules.kitty = _: {
    home.file.".config/kitty/tmux-main.session".source = ../../dotfiles/kitty/tmux-main.session;

    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
    };
  };
}
