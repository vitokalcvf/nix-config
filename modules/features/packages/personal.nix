{ self, inputs, ... }:
{
  flake.nixosModules.personalPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.personal.enable = lib.mkEnableOption "personal packages";

      config = lib.mkIf config.my.packages.personal.enable {
        environment.systemPackages = with pkgs; [
          discord
          spotify
          calibre
        ];
      };
    };
}
