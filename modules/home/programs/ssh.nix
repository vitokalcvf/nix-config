_: {
  flake.homeModules.ssh = _: {
    programs.ssh = {
      enable = true;
      # A partir do home-manager recente, os defaults globais (Host *) sao
      # opt-in. Desativamos para manter o config enxuto e explicito.
      enableDefaultConfig = false;

      settings."github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      settings."monitoring.kot.com.br" = {
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      settings."nixos.intra.kot.com.br" = {
        User = "admin";
        IdentityFile = "~/.ssh/id_ed25519";
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
