{ self, ... }:
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
        self.nixosModules.secrets
      ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        # Deduplica arquivos identicos no store via hardlinks apos cada build.
        auto-optimise-store = true;
      };

      # Coleta de lixo automatica semanal, mantendo as geracoes dos ultimos 14 dias.
      # O `just gc` continua disponivel para uma limpeza manual mais agressiva.
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      nixpkgs.config.allowUnfree = true;
    };
}
