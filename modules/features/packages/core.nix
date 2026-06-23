_: {
  flake.nixosModules.corePackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.core.enable = lib.mkEnableOption "core command-line packages";

      config = lib.mkIf config.my.packages.core.enable {
        environment.systemPackages = with pkgs; [
          git
          neovim
          ripgrep
          fd
          fzf
          yazi
          lazygit
          unzip
          curl
          wget
          tmux
          just
          fastfetch
          btop
        ];
      };
    };
}
