_:
let
  dockerModule =
    { config, ... }:
    let
      userName = config.my.host.userName;
    in
    {
      # Habilita o daemon do Docker (inicia no boot) - requisito do WinBoat.
      virtualisation.docker.enable = true;

      # Adiciona o usuario ao grupo docker (merge com os grupos ja definidos em user.nix).
      users.users.${userName}.extraGroups = [ "docker" ];
    };
in
{
  flake.nixosModules.docker = dockerModule;
}
