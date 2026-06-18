{ self, inputs, ... }:
{
  flake.nixosModules.desktopAppPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.desktopApps.enable = lib.mkEnableOption "desktop application packages";

      config = lib.mkIf config.my.packages.desktopApps.enable {
        environment.systemPackages = with pkgs; [
          papirus-icon-theme
          google-chrome
          kitty
          nemo
          nautilus
          evince
          file-roller
          wl-clipboard
          grim
          slurp
          polkit_gnome
          wdisplays
          winboat
          zapzap
        ];
      };
    };
}
