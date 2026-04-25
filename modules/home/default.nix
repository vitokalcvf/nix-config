{ self, inputs, ... }: {
  flake.nixosModules.home = { pkgs, lib, ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.arthas = {
        home.stateVersion = "25.11";
        programs.kitty = {
          enable = true;
          extraConfig = builtins.readFile ../dotfiles/kitty/kitty.conf;
        };
      };
    };
  };
}