{ self, ... }:
{
  flake.nixosModules.home =
    {
      config,
      ...
    }:
    let
      userName = config.my.host.userName;
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.${userName} =
          { lib, pkgs, ... }:
          {
            imports = [
              self.homeModules.default
            ];

            home.stateVersion = "25.11";

            # Cria pastas padrao na raiz da home do usuario.
            home.activation.createDefaultDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              run mkdir -p "$HOME/projetos" "$HOME/kot-toolbox"
            '';

            gtk = {
              enable = true;
              gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
              gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
              iconTheme = {
                name = "Papirus-Dark";
                package = pkgs.papirus-icon-theme;
              };
            };
            dconf = {
              enable = true;
              settings."org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
              };
            };
            home.pointerCursor = {
              name = "breeze_cursors";
              package = pkgs.kdePackages.breeze;
              size = 24;
              gtk.enable = true;
              x11.enable = true;
            };
          };
      };
    };
}
