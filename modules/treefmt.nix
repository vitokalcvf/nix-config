{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  # treefmt-nix define o `nix fmt` (formatter) agregando varios formatadores.
  # Substitui o antigo formatter.nix (que so chamava nixfmt) e o `find ... nixfmt`
  # do justfile por um unico ponto de configuracao.
  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        nixfmt.enable = true; # formatacao (estilo RFC)
        deadnix.enable = true; # remove bindings/args nao usados
        statix.enable = true; # corrige antipadroes comuns de Nix
      };
    };
  };
}
