# nix-config

Configuração NixOS pessoal baseada em **flakes**, **flake-parts** e **import-tree**, com integração ao **Home Manager**. O foco é um laptop (`kot12` — IdeaPad Slim 3 15ARP10, AMD) rodando o compositor Wayland **Niri** com a shell **DankMaterialShell (DMS)**.

---

## Índice

- [Visão geral da arquitetura](#visão-geral-da-arquitetura)
- [Conceitos-chave](#conceitos-chave)
- [Estrutura de pastas e arquivos](#estrutura-de-pastas-e-arquivos)
- [Como o sistema se monta (fluxo de composição)](#como-o-sistema-se-monta-fluxo-de-composição)
- [Rodar em uma máquina nova](#rodar-em-uma-máquina-nova)
- [Comandos do dia a dia](#comandos-do-dia-a-dia)

---

## Visão geral da arquitetura

O repositório é organizado em **camadas**, da mais genérica para a mais específica:

```
flake.nix                → ponto de entrada; declara inputs e delega tudo ao import-tree
   │
   └── modules/          → TODO o resto é auto-importado recursivamente
         │
         ├── flake-parts.nix / formatter.nix   → infraestrutura do flake
         │
         ├── features/   → blocos reutilizáveis (cada um = 1 nixosModule)
         ├── home/       → módulos do Home Manager (dotfiles declarativos)
         ├── dotfiles/   → arquivos de config "crus" (nvim, tmux, kitty...)
         │
         ├── profiles/   → agrupam features em conjuntos coerentes
         │      base → niri-desktop → work        (cada um importa o anterior)
         │
         └── hosts/      → máquinas concretas; escolhem um profile + hardware
                kot12/   → o laptop atual
```

A regra mental é: **features** definem *o que existe*, **profiles** decidem *o que ligar junto*, e **hosts** definem *a máquina real* (hardware, hostname, usuário).

---

## Conceitos-chave

### `import-tree`
O `flake.nix` faz apenas:

```nix
outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
```

Ou seja: **todo arquivo `.nix` dentro de `modules/` é importado automaticamente** (recursivamente). Não existe lista manual de imports no flake — basta criar o arquivo na pasta certa que ele entra na avaliação. Arquivos com prefixo `_` (ex.: `_keybindings.nix`) são convenção de "parcial" importado manualmente por outro módulo, não pelo tree.

### `flake-parts`
Framework que organiza o flake em módulos. Cada arquivo em `modules/` é um módulo flake-parts que pode contribuir com:
- `flake.nixosModules.<nome>` — um módulo NixOS reutilizável.
- `flake.homeModules.<nome>` — um módulo Home Manager.
- `flake.nixosConfigurations.<host>` — uma máquina montável.
- `perSystem` — saídas por arquitetura (ex.: `formatter`, `packages`).

Os módulos se referenciam entre si por nome via `self.nixosModules.<nome>` e `self.homeModules.<nome>`.

### O namespace de opções `my.*`
Para não espalhar valores fixos pelo código, há opções customizadas centralizando os dados do host:

- `my.host.*` — nome, usuário, home, timezone, locale, teclado (definidas em `features/system/host-options.nix`).
- `my.packages.<grupo>.enable` — liga/desliga grupos de pacotes (core, dev, desktopApps, work, notes).
- `my.desktop.niri.displaySettings` — config declarativa de monitores do Niri (quando `null`, o DMS gerencia).

Assim, **adaptar a uma nova máquina é majoritariamente preencher `my.host`** em vez de editar dezenas de módulos.

---

## Estrutura de pastas e arquivos

### Raiz

| Arquivo | Função |
|---|---|
| `flake.nix` | Ponto de entrada. Declara os **inputs** (nixpkgs unstable, flake-parts, import-tree, home-manager, dms, quickshell, wrapper-modules) e delega a composição ao `import-tree ./modules`. |
| `flake.lock` | Versões fixadas (lock) de todos os inputs. Commitado para builds reproduzíveis. |
| `justfile` | Atalhos de comandos (`just switch`, `just build`, `just update`...). Define `host := "kot12"` como padrão. |
| `.gitignore` | Ignora `.codex`. |

### `modules/` — infraestrutura do flake

| Arquivo | Função |
|---|---|
| `flake-parts.nix` | Carrega o `flakeModules.modules`, declara a opção `flake.homeModules` e define os `systems` suportados (x86_64/aarch64 linux e darwin). |
| `formatter.nix` | Define `nixfmt` como formatador padrão (`nix fmt`). |

### `modules/profiles/` — conjuntos de features

Os profiles formam uma cadeia, cada um importando o anterior:

| Arquivo | Módulo | O que agrega |
|---|---|---|
| `base.nix` | `baseProfile` | Fundação de qualquer host: opções de host, usuário, locale, NetworkManager, auto-upgrade. Liga `nix-command`/`flakes` e `allowUnfree`. |
| `niri-desktop.nix` | `niriDesktopProfile` | Importa `base` + ambiente gráfico completo: Niri, DMS, Home Manager, áudio (PipeWire + fix Fuxi-H3), base de desktop e os grupos de pacotes core/dev/desktopApps/work/notes. |
| `work.nix` | `workProfile` | Importa `niri-desktop` + Docker, e **habilita** os grupos de pacotes (`my.packages.*.enable = true`). É o profile usado pelo `kot12`. |

### `modules/hosts/kot12/` — a máquina

| Arquivo | Módulo | Função |
|---|---|---|
| `default.nix` | — | Declara `flake.nixosConfigurations."kot12"`: junta o módulo de configuração do host com o módulo NixOS do Home Manager. É o que `nixos-rebuild --flake .#kot12` monta. |
| `configuration.nix` | `kot12Configuration` | Importa hardware + `workProfile` + boot. Preenche `my.host` (nome, usuário `vitor`, teclado br-abnt2/br), define senha inicial e `system.stateVersion`. |
| `hardware.nix` | `kot12Hardware` | Gerado pelo instalador + ajustes: módulos de kernel, UUIDs de partições (`/`, `/boot`, swap), microcode AMD e o **quirk do teclado i8042 no resume** (teclado interno morre após suspender). |

### `modules/features/` — blocos reutilizáveis

Cada arquivo expõe um `flake.nixosModules.<nome>`. Os de pacotes definem uma opção `my.packages.<grupo>.enable` e só aplicam quando ligada.

**`features/system/`** — base do sistema operacional:

| Arquivo | Módulo | Função |
|---|---|---|
| `host-options.nix` | `hostOptions` | Define o schema de opções `my.host.*` (nome, usuário, home, timezone, locale, teclado). |
| `user.nix` | `user` | Cria o usuário primário (a partir de `my.host`), com grupos `wheel`/`networkmanager`, shell **fish**. |
| `locale.nix` | `locale` | Timezone, locale padrão/extra (en_US + pt_BR) e layout de teclado (console + XKB). |
| `network-manager.nix` | `networkManager` | Hostname, NetworkManager (com plugin OpenVPN) e firewall. |
| `auto-upgrade.nix` | `autoUpgrade` | `system.autoUpgrade` semanal a partir do flake local; marca o repo como `safe.directory` para o serviço root conseguir ler o git no home. Não reinicia sozinho. |
| `boot/systemd-boot.nix` | `systemdBoot` | Bootloader systemd-boot com acesso a variáveis EFI. |

**`features/packages/`** — grupos de pacotes (todos com toggle `my.packages.*.enable`):

| Arquivo | Grupo | Conteúdo |
|---|---|---|
| `core.nix` | `core` | CLI essencial: git, neovim, ripgrep, fd, fzf, yazi, lazygit, tmux, just, btop... |
| `dev.nix` | `dev` | Toolchains e IDEs: gcc, make, python3, nodejs, dotnet, LSPs (nil, lua-language-server), nixfmt, vscode, jetbrains rider, claude-code, codex, gemini-cli, docker. |
| `desktop-apps.nix` | `desktopApps` | Apps gráficos: chrome, kitty, nemo/nautilus, evince, ferramentas Wayland (grim, slurp, wl-clipboard), zapzap, winboat... |
| `work.nix` | `work` | Trabalho: teams-for-linux, libreoffice, remmina. |
| `notes.nix` | `notes` | obsidian. |

**`features/` — outros domínios:**

| Arquivo | Módulo | Função |
|---|---|---|
| `virtualisation/docker.nix` | `docker` | Habilita o daemon Docker e põe o usuário no grupo `docker` (requisito do WinBoat). |
| `audio/pipewire.nix` | `pipewireAudio` | PipeWire (ALSA + Pulse + 32-bit) no lugar do PulseAudio, com rtkit. |
| `audio/fuxi-h3.nix` | `fuxiH3AudioFix` | Workaround para o DAC USB Fuxi-H3: força soft-mixer e abre o mixer de hardware no login. |
| `niri/default.nix` | `niri` | Configura o compositor **Niri** via `wrapper-modules`: gaps, blur, foco, touchpad, teclado, autostart do DMS e integração com `outputs.kdl`. Expõe `my.desktop.niri.displaySettings`. |
| `niri/_keybindings.nix` | *(parcial)* | Atalhos de teclado do Niri (importado pelo `default.nix`). |
| `niri/_window-rules.nix` | *(parcial)* | Regras de janela (opacidade, blur, cantos arredondados). |
| `desktop/base.nix` | `desktopBase` | Base do desktop: greetd (fallback tuigreet), portais XDG, polkit, gnome-keyring, gvfs/udisks, impressão, firefox, tema Qt/GTK. |
| `desktop/dms.nix` | `dms` | Integração da **DankMaterialShell**: shell e greeter (tela de login gráfica) sobre Niri + quickshell, com script de greeter instrumentado para logs. |

### `modules/home/` — Home Manager

| Arquivo | Módulo | Função |
|---|---|---|
| `default.nix` | `home` (nixosModule) | Conecta o Home Manager ao NixOS: `useGlobalPkgs`, importa `homeModules.default` para o usuário, configura tema dark (GTK/dconf), cursor e cria a pasta `~/kot-toolbox`. |
| `programs/default.nix` | `homeModules.default` | Agrega os módulos home: kitty, nvim, tmux, ssh, git. |
| `programs/git.nix` | `homeModules.git` | Identidade do git, branch padrão `main`, rebase no pull, autosetup de remote. |
| `programs/kitty.nix` | `homeModules.kitty` | Terminal kitty, lendo `dotfiles/kitty/kitty.conf` e a sessão tmux. |
| `programs/tmux.nix` | `homeModules.tmux` | tmux lendo `dotfiles/tmux/tmux.conf`. |
| `programs/nvim.nix` | `homeModules.nvim` | Linka `dotfiles/nvim` para `~/.config/nvim`. |
| `programs/ssh.nix` | `homeModules.ssh` | Config SSH explícita (sem defaults globais), com match blocks para github.com e hosts internos. |

### `modules/dotfiles/` — configs "cruas"

Arquivos de configuração tradicionais, referenciados pelos módulos home (via `readFile` ou symlink). Mantê-los como arquivos reais permite editar com syntax highlighting e ferramentas nativas.

| Caminho | Conteúdo |
|---|---|
| `kitty/kitty.conf`, `kitty/tmux-main.session` | Config do terminal e sessão tmux inicial. |
| `tmux/tmux.conf` | Config do tmux. |
| `nvim/` | Configuração completa do Neovim (lazy.nvim): `init.lua`, `lua/config/*` (options, keymaps, autocmds, lazy), `lua/plugins/*`, `stylua.toml`. |

---

## Como o sistema se monta (fluxo de composição)

```
nixos-rebuild switch --flake .#kot12
        │
        ▼
flake.nix  ── import-tree ──▶ avalia todos os modules/*.nix
        │
        ▼
hosts/kot12/default.nix  ── define nixosConfigurations.kot12
        │  importa
        ▼
hosts/kot12/configuration.nix (kot12Configuration)
        │  importa
        ├── kot12Hardware          (partições, kernel, quirks)
        ├── workProfile            (pacotes + docker)
        │     └── niriDesktopProfile
        │           ├── baseProfile (host/user/locale/rede/upgrade)
        │           ├── niri + dms + desktopBase
        │           ├── home  (Home Manager → dotfiles)
        │           └── pacotes + áudio
        └── systemdBoot
        │
        ▼
   sistema NixOS completo
```

---

## Rodar em uma máquina nova

> Pré-requisito: ter o NixOS instalado (instalador padrão), com a partição já montada em `/mnt` durante a instalação, **ou** uma instalação NixOS já funcionando que você queira migrar para este flake.

### 1. Instalar o NixOS base e habilitar flakes

Se ainda não tiver flakes habilitado no sistema temporário/instalador:

```bash
# habilita nix-command e flakes na sessão atual
export NIX_CONFIG="experimental-features = nix-command flakes"
```

### 2. Clonar o repositório

O caminho esperado é `~/nix-config` (o auto-upgrade e o greeter assumem esse local):

```bash
git clone <url-do-repo> ~/nix-config
cd ~/nix-config
```

### 3. Gerar o hardware da nova máquina

Cada máquina tem hardware diferente (discos, módulos de kernel). Gere o arquivo:

```bash
sudo nixos-generate-config --show-hardware-config
```

Use a saída para criar `modules/hosts/<novo-host>/hardware.nix`, **adaptando ao formato deste repo** (um `flake.nixosModules.<host>Hardware` que retorna o conteúdo). Compare com `modules/hosts/kot12/hardware.nix` como referência. O essencial a ajustar:

- `boot.initrd.availableKernelModules` / `boot.kernelModules`
- `fileSystems."/"` e `fileSystems."/boot"` → **UUIDs reais** (veja `lsblk -f` ou `blkid`)
- `swapDevices` (UUID do swap, se houver)
- `nixpkgs.hostPlatform`
- Microcode (`hardware.cpu.amd` ou `hardware.cpu.intel`)

### 4. Criar o host

Crie `modules/hosts/<novo-host>/`:

- **`configuration.nix`** — copie de `kot12/configuration.nix` e ajuste:
  - `my.host.name` (hostname), `my.host.userName`, `my.host.homeDirectory`
  - teclado (`consoleKeyMap`, `layout`, `variant`)
  - escolha o profile a importar (`workProfile`, ou crie um mais enxuto)
  - **gere uma nova senha inicial**: `mkpasswd -m sha-512` e coloque em `initialHashedPassword`
  - `system.stateVersion` = versão do NixOS no momento da instalação
- **`default.nix`** — copie de `kot12/default.nix`, troque o nome da config e o módulo importado (`<novo-host>Configuration`).

> Os arquivos são auto-descobertos pelo `import-tree` — não precisa registrar em lugar nenhum.

### 5. (Opcional) Ajustar dados pessoais

- `modules/home/programs/git.nix` → nome/email do git
- `modules/home/programs/ssh.nix` → seus match blocks
- Coloque sua chave SSH em `~/.ssh/id_ed25519` (referenciada pelo ssh.nix)

### 6. Validar e aplicar

```bash
# valida a avaliação do flake
just check          # = nix flake check

# constrói sem aplicar (pega erros antes)
just build <novo-host>     # = nixos-rebuild build --flake .#<novo-host>

# aplica de verdade (precisa de sudo)
just switch <novo-host>    # = sudo nixos-rebuild switch --flake .#<novo-host>
```

Se `<novo-host>` for igual ao padrão do `justfile` (`kot12`), basta `just switch`.

Para a **primeira instalação a partir do instalador** (sistema ainda em `/mnt`), use:

```bash
sudo nixos-install --flake ~/nix-config#<novo-host>
```

### 7. Pós-instalação

- Faça login com a senha inicial e troque com `passwd`.
- Reinicie para carregar kernel/firmware definitivos.

---

## Comandos do dia a dia

Todos via `just` (veja `just --list`). `host` default = `kot12`.

| Comando | O que faz |
|---|---|
| `just switch [host]` | Aplica a config e torna padrão no boot (sudo). |
| `just test [host]` | Aplica temporariamente, **sem** virar default no boot. |
| `just build [host]` | Só constrói (valida mudanças sem aplicar). |
| `just update` | Atualiza todos os inputs do flake (`nix flake update`) — reescreve o `flake.lock`. |
| `just check` | `nix flake check` (avaliação + checks). |
| `just fmt` | Formata todos os `.nix` com nixfmt. |
| `just gc` | Remove gerações antigas e coleta lixo do store (sudo). |

> **Atualizações automáticas:** o `autoUpgrade` reconstrói semanalmente a partir de `~/nix-config#<host>`, puxando o nixpkgs unstable mais recente sem reescrever o lock. Para fixar versões, rode `just update` e commite o `flake.lock`.
