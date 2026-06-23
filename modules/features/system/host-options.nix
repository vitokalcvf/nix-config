_: {
  flake.nixosModules.hostOptions =
    { lib, config, ... }:
    {
      options.my.host = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "nixos";
          description = "NixOS networking hostname for this host.";
        };

        userName = lib.mkOption {
          type = lib.types.str;
          default = "vitor";
          description = "Primary local user for host-specific paths and Home Manager config.";
        };

        userDescription = lib.mkOption {
          type = lib.types.str;
          default = "Vitor Lima";
          description = "Full name for the primary local user.";
        };

        homeDirectory = lib.mkOption {
          type = lib.types.str;
          default = "/home/${config.my.host.userName}";
          defaultText = lib.literalExpression ''"/home/''${config.my.host.userName}"'';
          description = "Home directory for the primary local user.";
        };

        timeZone = lib.mkOption {
          type = lib.types.str;
          default = "America/Sao_Paulo";
          description = "System time zone.";
        };

        defaultLocale = lib.mkOption {
          type = lib.types.str;
          default = "en_US.UTF-8";
          description = "System default locale.";
        };

        extraLocale = lib.mkOption {
          type = lib.types.str;
          default = "pt_BR.UTF-8";
          description = "Locale used for regional LC_* settings.";
        };

        keyboard = {
          consoleKeyMap = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "Console keymap.";
          };

          layout = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "XKB keyboard layout.";
          };

          variant = lib.mkOption {
            type = lib.types.str;
            default = "intl";
            description = "XKB keyboard variant.";
          };
        };
      };
    };
}
