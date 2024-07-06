{
  description = " A material you color generation tool for linux ";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };
  outputs = { self, nixpkgs, systems }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);
      pkgsFor = nixpkgs.legacyPackages;
      callPackageForAll = path: forAllSystems (system: {
        default = pkgsFor.${system}.callPackage path { };
      });
    in {
      packages = callPackageForAll ./nix;
      devShells = callPackageForAll ./nix/shell.nix;
      
      homeManagerModules = rec {
        matugen = import ./nix/module.nix self;
        default = matugen;
      };
    };
}
