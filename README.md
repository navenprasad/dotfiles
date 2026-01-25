# Dotfiles

Personal dotfiles for macOS development.

- Theme and terminal setup
- Python with Conda/Mamba and PyTorch (MPS on Apple Silicon)
- Zsh aliases for fast environment workflows

---

## Quickstart

Fresh machine:

```bash
git clone git@github.com:YOURUSER/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh
stow conda
exec zsh
mk-torch
act-torch
```

---

## Tech stack

- ![Zsh](https://github.com/ohmyzsh.png?size=16) Zsh for shell
- ![Conda](https://github.com/conda.png?size=16) Conda / Mamba for Python envs
- ![PyTorch](https://github.com/pytorch.png?size=16) PyTorch with MPS (Apple Silicon)

---

## Setup details

### Zsh

Zsh config lives in `zsh/.zshrc` and is symlinked into `$HOME` via `stow`.

Helpers:

```bash
alias mk-torch='mamba env create -f ~/dotfiles/conda/torch.yml'
alias act-torch='mamba activate torch'
alias deactivate='mamba deactivate || conda deactivate'
```

Reload Zsh after stowing:

```bash
exec zsh
```

---

## Python / PyTorch

Create and activate the dedicated `torch` env:

```bash
mk-torch
act-torch
```

Verify PyTorch and Apple MPS support:

```bash
python - << 'EOF'
import torch
print("PyTorch:", torch.__version__)
print("MPS available:", torch.backends.mps.is_available())
print("MPS built:", torch.backends.mps.is_built())
EOF
```

Run a command inside the env without activating:

```bash
mamba run -n torch mycommand
```

---

## TODO

- UV setup for Python apps
- Ruby setup
- Go setup
- Expo setup
