{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaUser = { pkgs, ... }: {
    programs.fish.enable = true;

    users.users.arthas = {
      isNormalUser = true;
      description = "Arthur Barbosa Azevedo";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.fish;
    };
  };
}
