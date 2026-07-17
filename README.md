# 📂 .dotfiles

Welcome to my personal dotfiles repository. This repo houses my highly optimized, keyboard-driven development environment configurations. It is designed for maximum efficiency, clean typography, and a seamless terminal-based workflow.

---

## 🚀 Tech Stack & Highlights

*   **Shell:** [Fish Shell](https://fishshell.com/) — A smart, user-friendly command-line shell with auto-suggestions, interactive tab-completions, and clean syntax.
*   **Prompt:** [Starship](https://starship.rs/) — The minimal, blazing-fast, and extremely customizable cross-shell prompt.
*   **Editor:** [Neovim](https://neovim.io/) (via [NvChad](https://nvchad.com/)) — A blazingly fast IDE experience featuring:
    *   **Package Manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) for fast, asynchronous plugin loading.
    *   **LSP & Autocomplete:** Configured with `nvim-lspconfig`, `mason.nvim`, and specialized tools for **Go (Golang)**, **TypeScript/React (Next.js)**, **Dart/Flutter**, **Tailwind CSS**, and **PostgreSQL**.
    *   **Fuzzy Finder:** [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for finding files, grep searching, and quick LSP navigation.
    *   **Statusline:** Customized [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) featuring a perfectly centered clock.
    *   **Formatting:** [conform.nvim](https://github.com/stevearc/conform.nvim) for reliable, format-on-save configurations.

---

## 📂 Repository Structure

```text
.
├── fish/
│   └── config.fish        # Fish shell configuration, custom aliases, and path exports
├── nvim/                  # NvChad-based custom Neovim configuration
│   ├── init.lua           # Neovim entry point
│   ├── lazy-lock.json     # Locked plugin versions for reproducibility
│   └── lua/
│       ├── autocmds.lua   # Custom event-driven automation rules (e.g., custom filetypes)
│       ├── chadrc.lua     # Core NvChad overrides (default UI adjustments)
│       ├── mappings.lua   # Global & custom editor keybindings
│       ├── options.lua    # Vim/Neovim engine options & variables
│       ├── configs/       # Dedicated tool & plugin configurations
│       │   ├── conform.lua     # Code formatting engine setup
│       │   ├── lspconfig.lua   # Dev servers (Go, TypeScript, Dart, etc.)
│       │   ├── lualine.lua     # Custom centered-clock statusline
│       │   └── telescope.lua   # File search & fuzzy-finding parameters
│       ├── custom/
│       │   └── chadrc.lua     # User-level NvChad overrides (disabling statusline for lualine)
│       └── plugins/
│           └── init.lua       # Additional lazy-loaded Neovim plugins
└── starship/
    └── starship.toml      # Minimalist prompt theme & configurations
```

---

## 🛠️ Installation & Setup

### 1. Prerequisites
Ensure you have the required CLI applications installed on your system:
*   **Fish Shell** (`fish`)
*   **Neovim** (`nvim` 0.10+)
*   **Starship** (`starship`)
*   **Nerd Font** (e.g., *JetBrainsMono Nerd Font* for UI icons and glyphs)

### 2. Clone the Repository
Clone this repository directly into your home directory:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Symlink Configurations
Run the following commands in your terminal to link these configuration files to their target config directories:

```bash
# Create the parent config directories if they don't exist
mkdir -p ~/.config/fish ~/.config/nvim ~/.config/starship

# Link Fish Config
ln -sf ~/.dotfiles/fish/config.fish ~/.config/fish/config.fish

# Link Starship Config
ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

# Link Neovim Config
ln -sf ~/.dotfiles/nvim ~/.config/nvim
```

### 4. Initialize Plugins
*   **Fish:** Starship and configuration parameters will load automatically on the next shell spawn.
*   **Neovim:** Open `nvim`. On first launch, `lazy.nvim` will automatically bootstrap and install all specified plugins, LSPs, and parsers.

---

## ⌨️ Key Custom Mappings (Neovim)

*   `gd` / `Ctrl-click` — Go to LSP definition.
*   `gr` — Find LSP references.
*   `gs` — Go to LSP definition in a vertical split.
*   `<leader>fu` — Open Telescope LSP references fuzzy finder.
*   `<2-LeftMouse>` (Double click) — Go to definition inside React, TS, and JS files.
*   `<leader>e` — Search for files using Telescope matching the word currently under the cursor.

---

## 📄 License
This repository is licensed under the **MIT License**. Feel free to fork, adapt, and customize it to match your own development workflows!