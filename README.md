# Dotfiles

## Usage
1. Clone the repository

```bash
git clone https://github.com/sonofthecomet-ctrl/dotfiles
```

2. Install gnu stow. You can find the official instructions to do so [here](https://www.gnu.org/software/stow/).


3. Make sure you don't have any conflicting configurations at the same path - stow will create symlinks from the root of the `dotfiles` directory to the root of your computer -  then run stow using the following  command.

```bash
stow . 
``` 

## Project Structure
```bash
├── fish
│   ├── completions
│   ├── conf.d
│   │   ├── fish_frozen_theme.fish
│   │   └── rustup.fish
│   ├── config.fish
│   ├── fish_variables
│   └── functions
│       └── fish_prompt.fish
├── ghostty
│   └── config.toml
├── karabiner
│   ├── assets
│   │   └── complex_modifications
│   ├── automatic_backups
│   │   └── karabiner_20260726.json
│   └── karabiner.json
└── nvim
    ├── formatter
    │   └── eclipse-java-google-style.xml
    ├── ftplugin
    │   └── java.lua
    ├── init.lua
    ├── LICENSE
    └── lua
        ├── core
        │   ├── autocmds.lua
        │   ├── keymaps.lua
        │   └── options.lua
        └── plugins
            └── init.lua
```

 

