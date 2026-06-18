{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      dmsPackage = inputs.dms.packages.${system}.default;
      dmsOutputsPath = "${config.my.host.homeDirectory}/.config/niri/dms/outputs.kdl";

      windowRules = import ./_window-rules.nix;

      mkBaseSettings = homeDirectory: {
        spawn-at-startup = [
          [
            (lib.getExe dmsPackage)
            "run"
            "${homeDirectory}/.local/bin/niri-sidebar"
            "listen"
          ]
        ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb = {
          layout = config.my.host.keyboard.layout;
          variant = config.my.host.keyboard.variant;
        };
        input.touchpad = {
          # Habilita tap-to-click (toque na superficie = clique).
          tap = _: { };
          # Inverte a direcao da rolagem (conteudo acompanha os dedos).
          natural-scroll = _: { };
        };
        layout = {
          gaps = 18;
          focus-ring = {
            width = 2;
            active-color = "#ffffff";
          };
          border.off = _: { };
        };
        prefer-no-csd = true;
        blur = {
          passes = 2;
          offset = 1.5;
          noise = 0.01;
          saturation = 1.0;
        };
        window-rules = windowRules;
        binds = import ./_keybindings.nix {
          inherit
            lib
            pkgs
            dmsPackage
            homeDirectory
            ;
        };
      };
    in
    {
      options.my.desktop.niri.displaySettings = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
        description = "Host-specific declarative Niri display settings. When null, DMS may manage outputs.";
      };

      config.programs.niri = {
        enable = true;
        package = inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = lib.recursiveUpdate (mkBaseSettings config.my.host.homeDirectory) (
            if config.my.desktop.niri.displaySettings == null then
              { }
            else
              config.my.desktop.niri.displaySettings
          );
          extraSettings = lib.optionals (config.my.desktop.niri.displaySettings == null) [
            {
              include = [
                { optional = true; }
                dmsOutputsPath
              ];
            }
          ];
        };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myDms = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
}
