{ self, inputs, ... }:
{
  flake.nixosModules.desktopBasePackages =
    { ... }:
    {
      imports = [
        self.nixosModules.corePackages
        self.nixosModules.devPackages
        self.nixosModules.desktopAppPackages
        self.nixosModules.workPackages
        self.nixosModules.notesPackages
        self.nixosModules.mediaPackages
      ];

      my.packages = {
        core.enable = true;
        dev.enable = true;
        desktopApps.enable = true;
        work.enable = true;
        notes.enable = true;
        media.enable = true;
      };
    };
}
