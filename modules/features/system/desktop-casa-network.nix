{ self, inputs, ... }: {
  flake.nixosModules.desktopCasaNetwork = { ... }: {
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 8080 9090 ];
    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
