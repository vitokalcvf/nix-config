{ self, inputs, ... }:
{
  flake.nixosModules.personalDesktopProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.niriWorkstationProfile
        self.nixosModules.nvidiaDesktop
        self.nixosModules.gaming
      ];

      my.packages = {
        core.enable = true;
        dev.enable = true;
        desktopApps.enable = true;
        work.enable = true;
        notes.enable = true;
        personal.enable = true;
        media.enable = true;
      };
    };
}
