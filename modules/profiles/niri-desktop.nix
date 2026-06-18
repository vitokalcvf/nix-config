{ self, inputs, ... }:
{
  flake.nixosModules.niriDesktopProfile =
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
        self.nixosModules.desktopBase
        self.nixosModules.pipewireAudio
        self.nixosModules.fuxiH3AudioFix
      ];
    };
}
