set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Lista os comandos disponiveis.
default:
    just --list

# Sincroniza configuracoes runtime do Noctalia para o repositorio.
sync-noctalia:
    bash scripts/sync-noctalia-config
