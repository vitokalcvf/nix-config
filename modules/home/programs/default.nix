{ self, ... }:
{
  flake.homeModules.default =
    { ... }:
    {
      imports = [
        self.homeModules.kitty
        self.homeModules.nvim
        self.homeModules.tmux
        self.homeModules.ssh
        self.homeModules.git
      ];
    };
}
