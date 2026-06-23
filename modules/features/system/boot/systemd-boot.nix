_: {
  flake.nixosModules.systemdBoot = _: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
