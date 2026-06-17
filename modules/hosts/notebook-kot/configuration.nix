{ self, inputs, ... }:
{
  flake.nixosModules.notebookKotConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.notebookKotHardware
        self.nixosModules.workLaptopProfile
        self.nixosModules.systemdBoot
      ];

      my.host = {
        name = "kot12";
        userName = "vitor";
        homeDirectory = "/home/vitor";
        keyboard = {
          consoleKeyMap = "br-abnt2";
          layout = "br";
          variant = "";
        };
      };

      # Senha inicial temporaria. Troque no primeiro login com `passwd`.
      users.users.vitor.initialPassword = "vitor";

      system.stateVersion = "26.05";
    };
}
