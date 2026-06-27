_: {
  flake.nixosModules.grub = _: {
    # Desabilita o systemd-boot para nao conflitar com o GRUB na mesma ESP.
    boot.loader.systemd-boot.enable = false;

    boot.loader.efi = {
      canTouchEfiVariables = true;
      # ESP do NixOS (nvme1n1p1). O GRUB e instalado aqui.
      efiSysMountPoint = "/boot";
    };

    boot.loader.grub = {
      enable = true;
      efiSupport = true;
      # Em UEFI o GRUB nao escreve no MBR de um disco; usa a ESP.
      device = "nodev";

      # Detecta automaticamente o Windows na ESP do outro SSD (nvme0n1p1)
      # e cria a entrada de boot correspondente.
      useOSProber = true;

      # Entrada padrao e quanto tempo o menu espera (segundos) antes de
      # bootar a opcao padrao. Ajuste a gosto.
      default = 0;
    };

    # Tempo do menu do GRUB antes de iniciar a opcao padrao.
    boot.loader.timeout = 5;
  };
}
