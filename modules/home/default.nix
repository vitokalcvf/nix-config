{ self, inputs, ... }: {
  flake.nixosModules.home = { pkgs, lib, ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.arthas = {
        home.stateVersion = "25.11";
        home.file.".config/kitty/tmux-main.session".source = ../dotfiles/kitty/tmux-main.session;
        programs.kitty = {
          enable = true;
          extraConfig = builtins.readFile ../dotfiles/kitty/kitty.conf;
        };
        programs.tmux = {
          enable = true;
          extraConfig = builtins.readFile ../dotfiles/tmux/tmux.conf;
        };
      };
    };
  };
}
