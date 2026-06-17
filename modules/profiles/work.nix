{ self, inputs, ... }:
{
  flake.nixosModules.workProfile =
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
        media.enable = false;
      };
    };
}

