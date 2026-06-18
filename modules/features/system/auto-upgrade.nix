{ self, inputs, ... }:
let
  autoUpgradeModule =
    { config, ... }:
    {
      system.autoUpgrade = {
        enable = true;

        # Reconstroi a partir deste flake. O hostname (config.my.host.name)
        # seleciona a nixosConfiguration correspondente.
        flake = "/home/vitor/nix-config#${config.my.host.name}";

        # Atualiza o input nixpkgs em memoria (puxa o nixos-unstable mais novo)
        # sem reescrever/commitar o flake.lock. Para fixar versoes, rode
        # `just update` manualmente e commite o lock.
        flags = [
          "--update-input"
          "nixpkgs"
          "--no-write-lock-file"
          "-L"
        ];

        dates = "weekly";
        randomizedDelaySec = "45min";

        # Nao reinicia sozinho; kernel/firmware novos so valem apos um reboot manual.
        allowReboot = false;
      };
    };
in
{
  flake.nixosModules.autoUpgrade = autoUpgradeModule;
}
