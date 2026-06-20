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

        settings."github.com" = {
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519";
          # So usa a chave declarada acima, sem oferecer outras do agent.
          IdentitiesOnly = true;
        };

        settings."ti.intra.kot.com.br" = {
          User = "root";
          IdentityFile = "~/.ssh/id_ed25519";
          IdentitiesOnly = true;
        };
      };
    };
}
