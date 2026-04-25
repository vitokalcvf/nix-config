{ self, inputs, ... }: {
  flake.nixosModules.noctalia = { pkgs, lib, ... }: {
    programs.noctalia-shell = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
    };
  };
  perSystem = { pkgs, lib, self', ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON
            (builtins.readFile ../dotfiles/noctalia/noctalia.json)).settings;
    };
  };
}
