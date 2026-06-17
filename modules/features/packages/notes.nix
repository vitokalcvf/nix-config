{ self, inputs, ... }:
{
  flake.nixosModules.notesPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.notes.enable = lib.mkEnableOption "notes packages";

      config = lib.mkIf config.my.packages.notes.enable {
        environment.systemPackages = with pkgs; [
          obsidian
        ];
      };
    };
}
