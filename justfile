set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

host := "kot12"

# Lista os comandos disponiveis.
default:
    just --list

# Aplica a configuracao no sistema atual (precisa de sudo).
switch host=host:
    sudo nixos-rebuild switch --flake .#{{host}}

# Testa a configuracao sem torna-la padrao no boot.
test host=host:
    sudo nixos-rebuild test --flake .#{{host}}

# Constroi a configuracao sem aplicar (util para validar mudancas).
build host=host:
    nixos-rebuild build --flake .#{{host}}

# Atualiza todos os inputs do flake.
update:
    nix flake update

# Verifica o flake (avaliacao e checks).
check:
    nix flake check

# Formata e faz lint de todo o projeto (treefmt: nixfmt + deadnix + statix).
fmt:
    nix fmt

# Remove geracoes antigas e coleta lixo do Nix store.
gc:
    sudo nix-collect-garbage -d
