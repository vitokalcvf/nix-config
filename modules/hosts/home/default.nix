{ self, inputs, ... }:
{
  flake.nixosConfigurations."home" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.homeConfiguration
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
