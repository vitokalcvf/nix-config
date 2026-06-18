{ self, inputs, ... }:
{
  flake.nixosModules.baseProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.hostOptions
        self.nixosModules.user
        self.nixosModules.locale
        self.nixosModules.networkManager
        self.nixosModules.autoUpgrade
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixpkgs.config.allowUnfree = true;
    };
}
