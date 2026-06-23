_:
let
  networkModule =
    { config, pkgs, ... }:
    {
      networking.hostName = config.my.host.name;
      networking.networkmanager.enable = true;
      networking.networkmanager.plugins = with pkgs; [
        networkmanager-openvpn
      ];
      networking.firewall.enable = true;
    };
in
{
  flake.nixosModules.networkManager = networkModule;
}
