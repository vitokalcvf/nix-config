{ self, inputs, ... }: {
    flake.nixosModules.desktopCasaConfiguration = { pkgs, lib, ... }: {
        imports =
            [ # Include the results of the hardware scan.
                self.nixosModules.desktopCasaHardware
                self.nixosModules.niri
                self.nixosModules.home
            ];

        environment.systemPackages = with pkgs; [
            papirus-icon-theme
            git
            neovim
            wget
            vim
            brave
            kitty
            vscode
            obsidian
            qbittorrent
            discord
            teams-for-linux
            spotify
            nemo
            ffmpegthumbnailer
            evince
            wl-clipboard
            grim
            polkit_gnome
            slurp
        ];

        # Ativar flakes
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        # Icones
        qt = {
          enable = true;
          platformTheme = "gtk2";
          style = "gtk2";
        };

        gtk.iconCache.enable = true;

        programs.niri = {
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
        };

        # Drivers nvidia
        hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            open = true; # driver open source da nvidia (recomendado para 4060)
            nvidiaSettings = true;
            package = pkgs.linuxPackages.nvidiaPackages.stable;
            };

        boot.blacklistedKernelModules = [ "nouveau" ];
        boot.kernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];

        services.xserver.videoDrivers = [ "nvidia" ];

        # Variaveis de ambiente
        environment.variables = {
            WLR_NO_HARDWARE_CURSORS = "1";
            LIBVA_DRIVER_NAME = "nvidia";
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            };

        # Bootloader.
        boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = true;
            };
        };

        networking.hostName = "Arthas"; # Define your hostname.
        # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        # Configure network proxy if necessary
        # networking.proxy.default = "http://user:password@proxy:port/";
        # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

        # Enable networking
        networking.networkmanager.enable = true;

        # Set your time zone.
        time.timeZone = "America/Sao_Paulo";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
            LC_ADDRESS = "pt_BR.UTF-8";
            LC_IDENTIFICATION = "pt_BR.UTF-8";
            LC_MEASUREMENT = "pt_BR.UTF-8";
            LC_MONETARY = "pt_BR.UTF-8";
            LC_NAME = "pt_BR.UTF-8";
            LC_NUMERIC = "pt_BR.UTF-8";
            LC_PAPER = "pt_BR.UTF-8";
            LC_TELEPHONE = "pt_BR.UTF-8";
            LC_TIME = "pt_BR.UTF-8";
        };

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        services.xserver.enable = true;

        services.displayManager.gdm.enable = true;
        services.displayManager.gdm.wayland = true;
        services.displayManager.defaultSession = "niri";

        services.gnome.gnome-keyring.enable = true;
        security.polkit.enable = true;
        xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        };

        # Configure keymap in X11
        services.xserver.xkb = {
            layout = "us";
            variant = "intl";
        };

        # Configure console keymap
        console.keyMap = "us";

        # Enable CUPS to print documents.
        services.printing.enable = true;

        # Enable sound with pipewire.
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            # If you want to use JACK applications, uncomment this
            #jack.enable = true;

            # use the example session manager (no others are packaged yet so this is enabled by default,
            # no need to redefine it in your config for now)
            #media-session.enable = true;
        };

        # Enable touchpad support (enabled default in most desktopManager).
        # services.xserver.libinput.enable = true;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.users.arthas = {
            isNormalUser = true;
            description = "Arthur Barbosa Azevedo";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [
            #  thunderbird
            ];
        };


        # Install firefox.
        programs.firefox.enable = true;

        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search, run:
        # $ nix search wget


        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
        # programs.mtr.enable = true;
        # programs.gnupg.agent = {
        #   enable = true;
        #   enableSSHSupport = true;
        # };

        # List services that you want to enable:

        # Enable the OpenSSH daemon.
        # services.openssh.enable = true;

        # Open ports in the firewall.
        # networking.firewall.allowedTCPPorts = [ ... ];
        # networking.firewall.allowedUDPPorts = [ ... ];
        # Or disable the firewall altogether.
        # networking.firewall.enable = false;

        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It‘s perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "25.11"; # Did you read the comment?
    };
}
