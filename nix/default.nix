{pkgs, lib}: let
  manifest = (pkgs.lib.importTOML ../Cargo.toml).package;
  fileset = lib.fileset.unions [
    ../src
    ../Cargo.lock
    ../Cargo.toml
  ];
in
  pkgs.rustPlatform.buildRustPackage {
    pname = manifest.name;
    version = manifest.version;
    cargoLock.lockFile = ../Cargo.lock;
    src = lib.fileset.toSource {
      inherit fileset;
      root = ../.;
    };
    meta.mainProgram = "matugen";
  }
