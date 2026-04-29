{ self, inputs, ... }: {
  flake.nixosModules.desktopBase = { pkgs, ... }: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
      settings = {
        Autologin = {
          Session = "niri";
          User = "arthas";
        };
        General = {
          DefaultSession = "niri";
        };
      };
    };

    services.desktopManager.plasma6.enable = false;

    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "gtk2";
    };

    gtk.iconCache.enable = true;

    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    services.printing.enable = true;
    programs.firefox.enable = true;
  };
}
