# Keybindings do Niri. Importado por ./default.nix.
# Recebe as dependencias necessarias para montar os comandos de spawn.
{
  lib,
  pkgs,
  dmsPackage,
  homeDirectory,
}:
{
  "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
  "Mod+Q".close-window = { };
  "Mod+S".spawn-sh = "${lib.getExe dmsPackage} ipc call spotlight toggle";
  "Mod+E".spawn-sh = lib.getExe pkgs.nautilus;
  "Mod+L".spawn-sh = "${lib.getExe dmsPackage} ipc call lock lock";
  "Mod+P".screenshot = { };
  "Mod+Shift+P".screenshot-screen = { };
  "Mod+Ctrl+P".screenshot-window = { };

  "Mod+Left".focus-column-left = { };
  "Mod+Right".focus-column-right = { };
  "Mod+Up".focus-window-up = { };
  "Mod+Down".focus-window-down = { };

  "Mod+Alt+Left".focus-monitor-left = { };
  "Mod+Alt+Right".focus-monitor-right = { };
  "Mod+Alt+Shift+Left".move-window-to-monitor-left = { };
  "Mod+Alt+Shift+Right".move-window-to-monitor-right = { };

  "Mod+Shift+Left".move-column-left = { };
  "Mod+Shift+Right".move-column-right = { };
  "Mod+Shift+Up".move-window-up = { };
  "Mod+Shift+Down".move-window-down = { };

  "Mod+W".toggle-column-tabbed-display = { };
  "Mod+A".consume-window-into-column = { };
  "Mod+Shift+A".expel-window-from-column = { };
  "Mod+R".switch-preset-column-width = { };
  "Mod+Shift+R".switch-preset-column-width-back = { };
  "Mod+V".switch-preset-window-height = { };
  "Mod+Shift+V".switch-preset-window-height-back = { };
  "Mod+Ctrl+V".reset-window-height = { };

  "Mod+1".focus-workspace = 1;
  "Mod+2".focus-workspace = 2;
  "Mod+3".focus-workspace = 3;
  "Mod+4".focus-workspace = 4;
  "Mod+5".focus-workspace = 5;
  "Mod+Page_Down".focus-workspace-down = { };
  "Mod+Page_Up".focus-workspace-up = { };
  "Mod+Tab".focus-workspace-previous = { };

  "Mod+Shift+1".move-column-to-workspace = 1;
  "Mod+Shift+2".move-column-to-workspace = 2;
  "Mod+Shift+3".move-column-to-workspace = 3;
  "Mod+Shift+4".move-column-to-workspace = 4;
  "Mod+Shift+5".move-column-to-workspace = 5;
  "Mod+Shift+Page_Down".move-window-to-workspace-down = { };
  "Mod+Shift+Page_Up".move-window-to-workspace-up = { };

  "Mod+F".maximize-column = { };
  "Mod+Shift+F".fullscreen-window = { };
  "Mod+Ctrl+F".maximize-window-to-edges = { };

  "Mod+Space".toggle-overview = { };
  "Mod+Shift+Space".toggle-window-floating = { };

  "Mod+B".spawn-sh = "${homeDirectory}/.local/bin/niri-sidebar toggle-window";
  "Mod+Shift+B".spawn-sh = "${homeDirectory}/.local/bin/niri-sidebar toggle-visibility";
  "Mod+Ctrl+B".spawn-sh = "${homeDirectory}/.local/bin/niri-sidebar flip";
  "Mod+Alt+B".spawn-sh = "${homeDirectory}/.local/bin/niri-sidebar reorder";

  "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
  "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
  "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
}
