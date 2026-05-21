{ inputs, ... }:
{
  flake.nixosModules.dms =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      dmsPackage = inputs.dms.packages.${system}.default;
      quickshellPackage = inputs.quickshell.packages.${system}.default;
      dmsGreeterLog = "/var/lib/dms-greeter/dms-greeter.log";
      dmsGreeterQuickshellLog = "/var/lib/dms-greeter/quickshell.log";
      dmsGreeterDebug = pkgs.writeShellScriptBin "dms-greeter-debug" ''
        set -eu

        export PATH="${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.xwayland-satellite
            quickshellPackage
            config.programs.niri.package
            pkgs.glib
          ]
        }:$PATH"
        export XDG_DATA_DIRS="${config.programs.niri.package}/share:${pkgs.adwaita-icon-theme}/share:${pkgs.hicolor-icon-theme}/share:/run/current-system/sw/share:/etc/profiles/per-user/arthas/share:/nix/var/nix/profiles/default/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
        export XCURSOR_PATH="${pkgs.adwaita-icon-theme}/share/icons:${pkgs.hicolor-icon-theme}/share/icons:/run/current-system/sw/share/icons:/etc/profiles/per-user/arthas/share/icons:/nix/var/nix/profiles/default/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
        export XCURSOR_THEME="Adwaita"
        export XDG_SESSION_TYPE=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export EGL_PLATFORM=gbm
        export DMS_RUN_GREETER=1
        export DMS_GREET_CFG_DIR="/var/lib/dms-greeter"
        export HOME="/var/lib/dms-greeter"
        export XDG_STATE_HOME="/var/lib/dms-greeter/.local/state"
        export XDG_DATA_HOME="/var/lib/dms-greeter/.local/share"
        export XDG_CACHE_HOME="/var/lib/dms-greeter/.cache"
        export RUST_LOG="warn"
        export NIRI_LOG="debug"

        mkdir -p "$XDG_STATE_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"
        : > "${dmsGreeterLog}"
        : > "${dmsGreeterQuickshellLog}"

        niri_config="$(mktemp)"
        printf "%s\n" \
          "hotkey-overlay {" \
          "    skip-at-startup" \
          "}" \
          "" \
          "environment {" \
          "    DMS_RUN_GREETER \"1\"" \
          "}" \
          "" \
          "debug {" \
          "  keep-max-bpc-unchanged" \
          "}" \
          "" \
          "gestures {" \
          "   hot-corners {" \
          "     off" \
          "   }" \
          "}" \
          "" \
          "layout {" \
          "  background-color \"#000000\"" \
          "}" \
          "" \
          "spawn-at-startup \"sh\" \"-c\" \"echo '[dms-greeter] starting quickshell' >> ${dmsGreeterQuickshellLog} 2>&1; qs -p ${dmsPackage}/share/quickshell/dms >> ${dmsGreeterQuickshellLog} 2>&1; status=\$?; echo \\\"[dms-greeter] quickshell exited with status \$status\\\" >> ${dmsGreeterQuickshellLog} 2>&1; niri msg action quit --skip-confirmation >> ${dmsGreeterQuickshellLog} 2>&1; exit \$status\"" \
          > "$niri_config"

        echo "[dms-greeter] starting niri with config $niri_config" >> "${dmsGreeterLog}"
        exec niri -c "$niri_config" >> "${dmsGreeterLog}" 2>&1
      '';
    in
    {
      imports = [
        inputs.dms.nixosModules.dank-material-shell
        inputs.dms.nixosModules.greeter
      ];

      services.greetd.settings.default_session.user = "greeter";
      services.greetd.settings.default_session.command =
        lib.mkForce "${dmsGreeterDebug}/bin/dms-greeter-debug";
      users.users.greeter.home = "/var/lib/dms-greeter";

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = false;
        package = dmsPackage;
        quickshell.package = quickshellPackage;

        greeter = {
          enable = true;
          package = dmsPackage;
          quickshell.package = quickshellPackage;
          compositor.name = "niri";
          configHome = "/home/arthas";
          logs = {
            save = true;
            path = dmsGreeterLog;
          };
        };
      };
    };
}
