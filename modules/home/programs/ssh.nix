{ ... }:
{
  flake.homeModules.ssh =
    { ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks."github.com" = {
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
          identitiesOnly = true;
        };

        matchBlocks."ti.intra.kot.com.br" = {
          user = "root";
          identityFile = "~/.ssh/id_ed25519";
          identitiesOnly = true;
        };
      };
    };
}
