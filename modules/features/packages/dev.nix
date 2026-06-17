{ self, inputs, ... }:
{
  flake.nixosModules.devPackages =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.packages.dev.enable = lib.mkEnableOption "development packages";

      config = lib.mkIf config.my.packages.dev.enable {
        environment.systemPackages = with pkgs; [
          gcc
          gnumake
          python3
          nodejs
          dotnet-sdk
          stylua
          lua-language-server
          nil
          nixfmt-rfc-style
          vscode
          gemini-cli
          codex
          claude-code
          docker
          jetbrains.rider
        ];
      };
    };
}
