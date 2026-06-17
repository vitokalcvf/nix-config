{ self, inputs, ... }:
let
  grubEfiModule =
    { ... }:
    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          copyKernels = true;
        };
      };
    };
in
{
  flake.nixosModules.grubEfiBoot = grubEfiModule;
}
