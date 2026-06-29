{ self, ... }:
{
  flake.nixosModules.homeConfiguration =
    {
      ...
    }:
    {
      imports = [
        self.nixosModules.homeHardware
        self.nixosModules.personalProfile
        self.nixosModules.grub
      ];

      my.host = {
        name = "home";
        userName = "vitor";
        keyboard = {
          consoleKeyMap = "br-abnt2";
          layout = "br";
          variant = "";
        };
      };

      # Senha inicial temporaria (hash de "vitor"). Troque no primeiro login com `passwd`.
      # Gere um novo hash com: mkpasswd -m sha-512
      users.users.vitor.initialHashedPassword = "$6$fJ8sjbOXA93BuVG6$GPPo3jPcSFhwpPSYRzuuYcDy4ngG0VLzA4PQQu3KzSTGMigeGqTnE5hTfg88S1h3Gz4aDLzMFx4UvUvszTD.l/";

      system.stateVersion = "26.05";
    };
}
