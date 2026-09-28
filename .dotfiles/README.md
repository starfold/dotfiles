# Dotfiles

Personal configuration files, tracked with a **bare Git repository**.

Files stay at their real paths under `$HOME` (`~/.zshrc`, `~/.config/nvim/`, …). Git metadata lives in `~/.dotfiles`, not in a `~/.git` folder. An alias named `dot` is just `git` pointed at those two locations.

```text
~/.dotfiles/     Git database only (history, objects, refs)
$HOME            Working tree (the live configs programs actually read)
dot              git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME
```

## Why a bare repo

A normal repo would keep copies (or require symlinks) in a project folder. Programs do not read that folder; they read `$HOME`. A bare repo has no working tree of its own, so `$HOME` *is* the working tree and nothing needs to be copied or linked.

`$HOME` is not a Git repository. Plain `git` in a random directory will not attach to this history. Only `dot` will.

## Prerequisites

- Git
- A remote (GitHub, GitLab, …). Prefer **private** unless every tracked file has been audited for secrets.

Replace `YOURUSER/dotfiles` below with the real remote.

## First machine (create the repo)

```bash
git init --bare "$HOME/.dotfiles"

alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# persist the alias in the shell rc you actually use
echo "alias dot='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> "$HOME/.zshrc"
# echo "alias dot='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> "$HOME/.bashrc"

dot config --local status.showUntrackedFiles no
```

`status.showUntrackedFiles no` is required. Without it, `dot status` lists everything in `$HOME`.

Add files **by path**. Never `dot add .` from `$HOME`.

```bash
dot add ~/.zshrc ~/.zprofile ~/.bashrc ~/.profile
dot add ~/.gitconfig
dot add ~/.tmux.conf
dot add ~/.config/nvim
# add other configs the same way

echo ".dotfiles" >> "$HOME/.gitignore"
dot add ~/.gitignore

dot commit -m "Initial dotfiles"
dot remote add origin git@github.com:YOURUSER/dotfiles.git
dot branch -M main
dot push -u origin main
```

## New machine (restore)

```bash
git clone --bare git@github.com:YOURUSER/dotfiles.git "$HOME/.dotfiles"

alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot config --local status.showUntrackedFiles no
```

Checkout often fails the first time because the OS already shipped a default `~/.bashrc` or `~/.zshrc`:

```bash
mkdir -p "$HOME/.dotfiles-backup"
# move only the files Git listed as blocking checkout
mv ~/.bashrc ~/.zshrc "$HOME/.dotfiles-backup/" 2>/dev/null || true

dot checkout
```

Put the `dot` alias in the checked-out shell rc if it is not already there, then open a new shell.

## Daily use

```bash
# after editing a tracked file
dot add ~/.zshrc
dot commit -m "Tweak prompt"
dot push

dot status
dot diff
dot log --oneline
dot pull    # on the other machine
```

Treat `dot` exactly like `git`. Conflicts from editing the same file on two machines are resolved in the real files under `$HOME`, then committed as usual.

## What to track

Track portable config:

- Shell rc and aliases
- Git config (no credentials)
- Editor, terminal, tmux
- Window manager / bar configs you want everywhere
- Tool configs under `~/.config/` that you customized and that contain no secrets

## What never to track

- Private keys: `~/.ssh/id_*` (public `*.pub` is fine)
- `~/.gnupg/` private material
- Tokens, passwords, cloud credentials, `.npmrc` / `.pypirc` with auth
- `~/.config/gh/hosts.yml` and similar host credential files
- Shell history (`~/.bash_history`, `~/.zsh_history`)
- Caches and machine junk (`~/.cache/`, most of `~/.local/share/`)

If a config file mixes settings and secrets, split the secrets out and source them:

```bash
# tracked, e.g. ~/.zshrc
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
```

Keep `~/.secrets` untracked.

## Machine-specific bits

Bare Git has no templates. Keep host differences in small sourced files:

```bash
HOST_RC="$HOME/.config/shell/$(hostname -s).zsh"
[[ -f "$HOST_RC" ]] && source "$HOST_RC"
```

```bash
case "$(uname -s)" in
  Darwin) source "$HOME/.config/shell/macos.zsh" ;;
  Linux)  source "$HOME/.config/shell/linux.zsh" ;;
esac
```

Leave purely local files untracked.

## Notes

- This repo does not install packages. Install nvim, tmux, the font, the terminal, etc. on the new machine first (or keep a separate package list).
- Scan staged diffs for tokens before the first push (`ghp_`, `AKIA`, `BEGIN OPENSSH PRIVATE KEY`, `password=`).
- If the remote is private, a raw `curl | bash` bootstrap will not work without auth. Clone with SSH or HTTPS, then check out.
