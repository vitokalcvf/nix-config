{ self, inputs, ... }: {
    flake.nixosConfigurations.vmTrabalho = inputs.nixpkgs.lib.nixosSystem {
        modules = [
            self.nixosModules.vmTrabalhoConfiguration
        ];
    };
}
