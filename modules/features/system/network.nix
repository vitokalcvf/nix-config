{ self, inputs, ... }:
let
  networkModule =
    { config, ... }:
    {
      networking.hostName = config.my.host.name;
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [
        8080
        9090
      ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
    };
in
{
  flake.nixosModules.networkManager = networkModule;
}
