{ self, ... }:
{
  flake.nixosModules.workProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriDesktopProfile
        self.nixosModules.docker
      ];

      my.packages = {
        core.enable = true;
        dev.enable = true;
        desktopApps.enable = true;
        work.enable = true;
        notes.enable = true;
      };
    };
}
