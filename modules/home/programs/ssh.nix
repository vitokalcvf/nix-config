{ ... }:
{
  flake.homeModules.ssh =
    { ... }:
    {
      programs.ssh = {
        enable = true;
        # A partir do home-manager recente, os defaults globais (Host *) sao
        # opt-in. Desativamos para manter o config enxuto e explicito.
        enableDefaultConfig = false;

        matchBlocks."github.com" = {
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
          # So usa a chave declarada acima, sem oferecer outras do agent.
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
