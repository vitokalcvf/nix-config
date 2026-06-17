{ self, inputs, ... }:
{
  flake.nixosModules.fuxiH3AudioFix =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        alsa-utils
      ];

      services.pipewire.wireplumber.extraConfig."50-fuxi-h3-soft-mixer" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.usb-XiiSound_Technology_Corporation_Fuxi-H3-00";
              }
            ];
            actions = {
              update-props = {
                "api.alsa.soft-mixer" = true;
              };
            };
          }
        ];
      };

      systemd.user.services.fuxi-h3-fix = {
        description = "Keep Fuxi-H3 hardware mixer fully open";
        after = [
          "graphical-session.target"
          "pipewire.service"
          "wireplumber.service"
        ];
        wantedBy = [ "default.target" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "fuxi-h3-fix" ''
            card="$(${pkgs.alsa-utils}/bin/aplay -l | ${pkgs.gnugrep}/bin/grep 'Fuxi-H3' | ${pkgs.gnused}/bin/sed -E 's/^card ([0-9]+):.*/\1/' | ${pkgs.coreutils}/bin/head -n1)"
            if [ -n "$card" ]; then
              ${pkgs.alsa-utils}/bin/amixer -c "$card" set 'PCM',0 100%,100% unmute
            fi
          '';
        };
      };
    };
}
