{
  description = "A material you color generation tool for linux";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    ndg.url = "github:feel-co/ndg";
  };
  outputs = {
    self,
    nixpkgs,
    systems,
    ndg,
  }: let
    # Inspired by
    # github:DavHau/nix-portable/5bccc8824c13c8efa97a4ea7ede35da83936c3cc/flake.nix#L23C7-L24C68
    forAllSystems = function:
      nixpkgs.lib.genAttrs (import systems) (system:
        function {
          inherit system;
          pkgs = nixpkgs.legacyPackages.${system};
        });

    pkgsFor = nixpkgs.legacyPackages;
  in {
    packages = forAllSystems ({
      system,
      pkgs,
    }: {
      default = pkgs.callPackage ./nix {};
      ndgDocs = pkgsFor.${system}.callPackage ./nix/docs.nix {inherit self ndg;};
    });
    devShells = forAllSystems ({pkgs, ...}: {
      default = pkgs.callPackage ./nix/shell.nix {};
    });

    homeManagerModules = rec {
      matugen = import ./nix/module {inherit self;};
      default = matugen;
    };
  };
}
