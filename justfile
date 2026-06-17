set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Lista os comandos disponiveis.
default:
    just --list
