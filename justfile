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

# Formata todos os arquivos .nix do projeto.
fmt:
    find modules flake.nix -name '*.nix' -print0 | xargs -0 nix fmt --

# Remove geracoes antigas e coleta lixo do Nix store.
gc:
    sudo nix-collect-garbage -d
