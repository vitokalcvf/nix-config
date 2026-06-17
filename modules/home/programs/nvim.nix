{ ... }:
{
  flake.homeModules.nvim =
    { ... }:
    {
      xdg.configFile."nvim".source = ../../dotfiles/nvim;
    };
}
