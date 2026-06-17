{ self, inputs, ... }:
let
  userModule =
    { config, pkgs, ... }:
    let
      userName = config.my.host.userName;
    in
    {
      programs.fish.enable = true;

      users.users.${userName} = {
        isNormalUser = true;
        description = config.my.host.userDescription;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.fish;
      };
    };
in
{
  flake.nixosModules.user = userModule;
}
