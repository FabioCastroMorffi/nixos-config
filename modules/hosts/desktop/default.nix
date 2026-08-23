{ self, inputs, ...}: {

  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.desktopConfiguration
];
  };

}
