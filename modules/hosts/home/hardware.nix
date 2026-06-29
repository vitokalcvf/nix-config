_: {
  flake.nixosModules.homeHardware =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # TEMPLATE: rode `sudo nixos-generate-config --show-hardware-config` na
      # maquina "home" e substitua os valores abaixo pelos detectados.
      # Os UUIDs, modulos de kernel e o microcode da CPU sao especificos do
      # hardware real e PRECISAM ser ajustados antes do primeiro build.

      # TODO: ajustar conforme o hardware real.
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "sdhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
      # TODO: "kvm-amd" para CPU AMD ou "kvm-intel" para CPU Intel.
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      # TODO: substituir os UUIDs pelos do disco da maquina home.
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/0000-0000";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      # TODO: ajustar/remover conforme houver swap na maquina home.
      swapDevices = [
        # { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      # TODO: para CPU Intel, troque por:
      #   hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
