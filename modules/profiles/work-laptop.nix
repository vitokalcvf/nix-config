{ self, inputs, ... }:
{
  flake.nixosModules.workLaptopProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriWorkstationProfile
      ];

      my.packages = {
        core.enable = true;
        dev.enable = true;
        desktopApps.enable = true;
        work.enable = true;
        notes.enable = true;
        personal.enable = false;
        media.enable = false;
      };
    };
}
