{ self, inputs, ... }: {
  flake.nixosModules.home = { pkgs, lib, ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.arthas = {
        home.stateVersion = "25.11";
        gtk = {
          enable = true;
          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };
        };
        home.pointerCursor = {
          name = "breeze_cursors";
          package = pkgs.kdePackages.breeze;
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };
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
