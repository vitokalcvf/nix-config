{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaConfiguration = { config, pkgs, lib, ... }: {
    imports = [
      self.nixosModules.desktopCasaHardware
      self.nixosModules.niri
      self.nixosModules.dms
      self.nixosModules.home
      self.nixosModules.desktopBasePackages
      self.nixosModules.desktopBase
      self.nixosModules.nvidiaDesktop
      self.nixosModules.pipewireAudio
      self.nixosModules.fuxiH3AudioFix
      self.nixosModules.desktopCasaBoot
      self.nixosModules.desktopCasaNetwork
      self.nixosModules.desktopCasaLocale
      self.nixosModules.desktopCasaUser
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";
  };
}
