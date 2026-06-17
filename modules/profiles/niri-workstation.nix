{ self, inputs, ... }:
{
  flake.nixosModules.niriWorkstationProfile =
    { ... }:
    {
      imports = [
        self.nixosModules.baseProfile
        self.nixosModules.niri
        self.nixosModules.dms
        self.nixosModules.home
        self.nixosModules.corePackages
        self.nixosModules.devPackages
        self.nixosModules.desktopAppPackages
        self.nixosModules.workPackages
        self.nixosModules.notesPackages
        self.nixosModules.personalPackages
        self.nixosModules.mediaPackages
        self.nixosModules.desktopBase
        self.nixosModules.pipewireAudio
        self.nixosModules.fuxiH3AudioFix
      ];
    };
}
