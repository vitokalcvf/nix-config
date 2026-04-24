{ self, inputs, ... }: {
    flake.nixosModules.vmTrabalhoHardware = { config, lib, pkgs, modulesPath, ... }:

    {
        imports = [ ];

        boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
            { device = "/dev/disk/by-uuid/1acf3147-0480-4e3c-9d01-abe2b1744413";
            fsType = "ext4";
            };

        swapDevices =
            [ { device = "/dev/disk/by-uuid/556d2b4c-2ecb-4d83-a1d0-743cf7f81709"; }
            ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        virtualisation.virtualbox.guest.enable = true;
    };
}
