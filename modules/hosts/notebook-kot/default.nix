{ self, inputs, ... }:
{
  flake.nixosConfigurations."kot12" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.notebookKotConfiguration
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}
