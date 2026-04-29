{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
    };
  };
  perSystem = { pkgs, lib, self', ... }: {
    packages = let
      baseSettings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb = {
          layout = "us";
          variant = "intl";
        };
        layout = {
          gaps = 18;
          focus-ring = {
            width = 2;
            active-color = "#ffffff";
          };
          border.off = _: {};
        };
        prefer-no-csd = true;
        blur = {
          passes = 2;
          offset = 1.5;
          noise = 0.01;
          saturation = 1.0;
        };
        window-rules = [
          {
            matches = [ { app-id = ".*"; } ];
            opacity = 0.87;
            geometry-corner-radius = 8;
            clip-to-geometry = true;
            draw-border-with-background = false;
            background-effect.blur = true;
            popups = {
              opacity = 0.95;
              geometry-corner-radius = 8;
              background-effect = {
                xray = true;
                blur = true;
              };
            };
          }
          {
            matches = [
              { app-id = "brave-browser"; }
              { app-id = "Brave-browser"; }
              { app-id = "firefox"; }
              { app-id = "chromium-browser"; }
              { app-id = "chromium"; }
              { app-id = "google-chrome"; }
            ];
            opacity = 1.0;
          }
        ];
        binds = {
          # Apps
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = {};
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+E".spawn-sh = lib.getExe pkgs.nemo;
          "Mod+Page_Up".spawn-sh = "${lib.getExe pkgs.slurp} | ${lib.getExe pkgs.grim} -g - - | tee ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy";
          
          # Foco entre janelas
          "Mod+Left".focus-column-left = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Up".focus-window-up = {};
          "Mod+Down".focus-window-down = {};
        
          # Mover janelas
          "Mod+Shift+Left".move-column-left = {};
          "Mod+Shift+Right".move-column-right = {};
          "Mod+Shift+Up".move-window-up = {};
          "Mod+Shift+Down".move-window-down = {};
        
          # Workspaces
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
        
          # Mover janela para workspace
          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
        
          # Tamanho das janelas
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};
        
          # Volume
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
      };
    in {
      myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = baseSettings;
      };
      myNiriDesktopCasa = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = lib.recursiveUpdate baseSettings (import ../../data/desktop-casa-display-settings.nix);
      };
    };
  };
}
