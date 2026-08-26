{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim-flake.url = "path:/home/fabio/my_github_clones/nvim-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs"; # optional line to avoid double downloads;
    };
  };
  # import modules auto
  outputs = inputs: inputs.flake-parts.lib.mkFlake 
  {inherit inputs;} 
  (inputs.import-tree ./modules);
}
