{ self, inputs, ... }:
let
  networkModule =
    { config, ... }:
    {
      networking.hostName = config.my.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    };
in
{
  flake.nixosModules.networkManager = networkModule;
}
