{ self, inputs, ... }: {
    flake.nixosConfigurations.desktopCasa = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [
            self.nixosModules.desktopCasaConfiguration
            inputs.home-manager.nixosModules.home-manager
        ];
    };
}
