_: {
  flake.nixosModules.kot12Hardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "sdhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/2918787d-6dc6-498b-804a-a91d43b0ba73";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/3D7D-4792";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/589c5b65-4ad6-4239-bfed-eb8d2c0f2003"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      # Quirk do teclado interno (IdeaPad Slim 3 15ARP10, AMD): apos suspender,
      # o controlador i8042 falha ao reativar o teclado PS/2
      # ("atkbd serio0: Failed to enable keyboard on isa0060/serio0") e o teclado
      # interno para de responder. Recarregar o i8042 com reset=1 no resume
      # reinicializa o controlador e devolve o teclado. O ideapad_laptop depende
      # do i8042, entao precisa sair antes e voltar depois.
      powerManagement.resumeCommands = ''
        ${pkgs.kmod}/bin/modprobe -r ideapad_laptop || true
        ${pkgs.kmod}/bin/rmmod i8042 || true
        ${pkgs.kmod}/bin/modprobe i8042 reset=1 || true
        ${pkgs.kmod}/bin/modprobe ideapad_laptop || true
      '';
    };
}
