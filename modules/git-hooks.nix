{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      # Roda o treefmt (nixfmt + deadnix + statix) como hook de pre-commit.
      # Tambem vira um check do flake (`nix flake check` falha se algo estiver
      # fora de formatacao).
      pre-commit.settings.hooks.treefmt = {
        enable = true;
        packageOverrides.treefmt = config.treefmt.build.wrapper;
      };

      # `nix develop` instala os hooks de git automaticamente neste repo e
      # disponibiliza as ferramentas de secrets (sops/age — veja README).
      devShells.default = pkgs.mkShell {
        inherit (config.pre-commit.devShell) shellHook;
        packages = config.pre-commit.settings.enabledPackages ++ [
          pkgs.sops
          pkgs.age
          pkgs.ssh-to-age
        ];
      };
    };
}
