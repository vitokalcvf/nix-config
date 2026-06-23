{ self, lib, ... }:
{
  # Expoe cada nixosConfiguration como um check, para que `nix flake check`
  # (e o `just check`) realmente *construa* o sistema, pegando erros de build
  # antes do `switch` em vez de so avaliar o flake.
  #
  # Filtra por arquitetura: cada perSystem so registra os hosts cuja
  # plataforma bate com o `system` atual, evitando cross-build acidental.
  perSystem =
    { system, ... }:
    {
      checks =
        lib.mapAttrs' (name: nixos: lib.nameValuePair "nixos-${name}" nixos.config.system.build.toplevel)
          (
            lib.filterAttrs (
              _: nixos: nixos.config.nixpkgs.hostPlatform.system == system
            ) self.nixosConfigurations
          );
    };
}
