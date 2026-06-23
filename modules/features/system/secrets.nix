{ inputs, ... }:
{
  # Gerenciamento de secrets com sops-nix.
  #
  # Fica DESLIGADO por padrao (`my.secrets.enable = false`): o modulo do
  # sops-nix e importado, mas sem nenhum secret definido ele e inerte e nao
  # afeta o build/activation. Para ligar, veja a secao "Secrets" no README.
  #
  # Este host nao roda servidor SSH, entao a identidade de descriptografia e
  # uma chave age propria em `/var/lib/sops-nix/keys.txt` (lida pelo root no
  # boot). O `.sops.yaml` na raiz lista os recipients (chaves age publicas).
  # Veja a secao "Secrets" no README para os comandos de setup.
  flake.nixosModules.secrets =
    { config, lib, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.my.secrets.enable = lib.mkEnableOption "gerenciamento de secrets com sops-nix";

      config = lib.mkIf config.my.secrets.enable {
        sops = {
          defaultSopsFile = ../../../secrets/secrets.yaml;
          age = {
            keyFile = "/var/lib/sops-nix/keys.txt";
            # Nao geramos a chave automaticamente: ela e criada uma vez com
            # `age-keygen` (veja o README) e seu .pub vai para o .sops.yaml.
            generateKey = false;
          };
        };

        # Exemplo de uso (descomente apos criar o secret `user-password`):
        #
        #   sops.secrets.user-password.neededForUsers = true;
        #   users.users.${config.my.host.userName} = {
        #     hashedPasswordFile = config.sops.secrets.user-password.path;
        #   };
        #
        # Lembre de remover o `initialHashedPassword` do host ao migrar.
      };
    };
}
