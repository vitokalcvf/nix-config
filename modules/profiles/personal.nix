{ self, ... }:
{
  flake.nixosModules.personalProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriDesktopProfile
        self.nixosModules.docker
      ];

      # Ambiente pessoal/caseiro: dev, notas e docker, sem nada vinculado ao
      # trabalho (my.packages.work fica desligado).
      my.packages = {
        core.enable = true;
        dev.enable = true;
        desktopApps.enable = true;
        notes.enable = true;
      };
    };
}
