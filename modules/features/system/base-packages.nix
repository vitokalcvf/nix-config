{ self, inputs, ... }: {
  flake.nixosModules.desktopBasePackages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      papirus-icon-theme
      git
      neovim
      wget
      brave
      kitty
      vscode
      obsidian
      qbittorrent
      discord
      teams-for-linux
      spotify
      nemo
      ffmpegthumbnailer
      evince
      wl-clipboard
      grim
      slurp
      polkit_gnome
      gemini-cli
      codex
      tmux
    ];
  };
}
