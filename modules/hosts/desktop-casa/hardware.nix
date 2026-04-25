{ self, inputs, ... }: {
    flake.nixosModules.desktopCasaHardware = { config, lib, pkgs, modulesPath, ... }:

    {
        imports =
            [ (modulesPath + "/installer/scan/not-detected.nix")
            ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
            { device = "/dev/disk/by-uuid/349e9eb6-aa1f-482e-be3d-a5c5c669f315";
            fsType = "ext4";
            };

        fileSystems."/boot" =
            { device = "/dev/disk/by-uuid/B4A9-B746";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
            };

        swapDevices =
            [ { device = "/dev/disk/by-uuid/d3ca76e0-0da8-47ea-a6bd-f7e94d258f3a"; }
            ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            };

}
