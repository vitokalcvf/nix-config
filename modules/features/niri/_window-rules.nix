# Regras de janela do Niri (estaticas). Importado por ./default.nix.
[
  {
    matches = [ { app-id = ".*"; } ];
    opacity = 0.87;
    geometry-corner-radius = 8;
    clip-to-geometry = true;
    draw-border-with-background = false;
    background-effect.blur = true;
    popups = {
      opacity = 0.95;
      geometry-corner-radius = 8;
      background-effect = {
        xray = true;
        blur = true;
      };
    };
  }
  {
    matches = [
      { app-id = "brave-browser"; }
      { app-id = "Brave-browser"; }
      { app-id = "firefox"; }
      { app-id = "chromium-browser"; }
      { app-id = "chromium"; }
      { app-id = "google-chrome"; }
    ];
    opacity = 1.0;
  }
  {
    matches = [
      { app-id = "discord"; }
      { app-id = "Discord"; }
    ];
    opacity = 1.0;
    background-effect.blur = false;
    popups.background-effect.blur = false;
  }
  {
    matches = [ { is-floating = true; } ];
    min-width = 100;
    min-height = 100;
  }
]
