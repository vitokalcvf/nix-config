{ self, inputs, ... }: {
    flake.nixosModules.vmCasaHardware = { config, lib, pkgs, modulesPath, ... }:

    {
        imports =
            [ (modulesPath + "/profiles/qemu-guest.nix")
            ];

        boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
            { device = "/dev/disk/by-uuid/ffd18506-55f6-4d78-9b7d-c87f03e65a38";
            fsType = "ext4";
            };

        swapDevices =
            [ { device = "/dev/disk/by-uuid/f05f7c29-5367-4391-af97-0c8d98337a2c"; }
            ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };

}
