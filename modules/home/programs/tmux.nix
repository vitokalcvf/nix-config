{ ... }:
{
  flake.homeModules.tmux =
    { ... }:
    {
      programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ../../dotfiles/tmux/tmux.conf;
      };
    };
}
