_: {
  flake.nixosModules.desktopBase =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = lib.mkDefault (!config.programs.dank-material-shell.greeter.enable);
        settings.default_session = lib.mkIf (!config.programs.dank-material-shell.greeter.enable) {
          user = "greeter";
          command = lib.escapeShellArgs [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--cmd"
            "${config.programs.niri.package}/bin/niri-session"
            "--greeting"
            "Seja bem-vindo!"
            "--time"
            "--time-format"
            "%H:%M"
            "--remember"
            "--asterisks"
            "--width"
            "60"
            "--container-padding"
            "1"
            "--prompt-padding"
            "1"
            "--greet-align"
            "center"
            "--theme"
            "border=#a89984;text=#ebdbb2;prompt=#b8bb26;time=#fabd2f;action=#fe8019;button=#83a598;container=#282828;input=#fbf1c7"
          ];
        };
      };

      qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
      };

      gtk.iconCache.enable = true;

      services.gnome.gnome-keyring.enable = true;
      security.polkit.enable = true;
      services.udisks2.enable = true;
      services.gvfs.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };

      services.printing.enable = true;
      programs.firefox.enable = true;
    };
}
