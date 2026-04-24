{ self, inputs, ... }: {
    flake.nixosConfigurations.vmCasa = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.vmCasaConfiguration
        ];
    };
}
