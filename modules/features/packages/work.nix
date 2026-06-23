_: {
  flake.nixosModules.workPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.work.enable = lib.mkEnableOption "work packages";

      config = lib.mkIf config.my.packages.work.enable {
        environment.systemPackages = with pkgs; [
          teams-for-linux
          libreoffice
          remmina
        ];
      };
    };
}
