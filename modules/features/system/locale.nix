{ self, inputs, ... }:
let
  localeModule =
    { config, ... }:
    {
      time.timeZone = config.my.host.timeZone;

      i18n.defaultLocale = config.my.host.defaultLocale;
      i18n.extraLocaleSettings = {
        LC_ADDRESS = config.my.host.extraLocale;
        LC_IDENTIFICATION = config.my.host.extraLocale;
        LC_MEASUREMENT = config.my.host.extraLocale;
        LC_MONETARY = config.my.host.extraLocale;
        LC_NAME = config.my.host.extraLocale;
        LC_NUMERIC = config.my.host.extraLocale;
        LC_PAPER = config.my.host.extraLocale;
        LC_TELEPHONE = config.my.host.extraLocale;
        LC_TIME = config.my.host.extraLocale;
      };

      console.keyMap = config.my.host.keyboard.consoleKeyMap;
      services.xserver.xkb = {
        layout = config.my.host.keyboard.layout;
        variant = config.my.host.keyboard.variant;
      };
    };
in
{
  flake.nixosModules.locale = localeModule;
}
