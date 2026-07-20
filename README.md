# Nix Config

This is my Nix setup managing my not so many packages and configurations -- as of now -- with a modular structure.

- `modules:` Contains all Features and Hosts in the current config
- `features:` Section reserved to packages that require extra wrapping (i.e. nvim)
- `hosts:` Contains all current hosts that themselves have the typical `configuration.nix` `hardware-configuration.nix`and `home.nix` files.

## Usage
Build NixOS config with both root and home packages for either host:
`sudo nixos-rebuild switch --flake .#{Host}` or `make {Host}`

Otherwise, if you'd like to try out the config beforehand:
`sudo nixos-rebuild test --flake github:FabioCastroMorffi/nixos-config#<Host>`
## Structure
`
.
├── flake.lock
├── flake.nix
├── modules
│   ├── features                    # Additional packages that require wrapping
│   │   ├── niri.nix
│   │   ├── noctalia.json
│   │   ├── noctalia.nix
│   │   ├── nvim                    # Nvim config in Lua
│   │   │   ├── init.lua
│   │   │   ├── lazy-lock.json
│   │   │   ├── lazyvim.json
│   │   │   ├── LICENSE
│   │   │   ├── lua
│   │   │   │   ├── config
│   │   │   │   │   ├── autocmds.lua
│   │   │   │   │   ├── keymaps.lua
│   │   │   │   │   ├── lazy.lua
│   │   │   │   │   └── options.lua
│   │   │   │   └── plugins
│   │   │   │       └── example.lua
│   │   │   ├── nvim-pack-lock.json
│   │   │   ├── README.md
│   │   │   └── stylua.toml
│   │   └── nvim.nix
│   ├── hosts                       # Two main hosts currently: Desktop and Laptop
│   │   ├── desktop
│   │   │   ├── configuration.nix
│   │   │   ├── default.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   └── home.nix
│   │   └── thinkpad
│   │       ├── configuration.nix
│   │       ├── default.nix
│   │       ├── hardware-configuration.nix
│   │       └── home.nix
│   └── parts.nix
├── README.md
└── settings.json
`
