{pkgs, lib}: let
  manifest = (pkgs.lib.importTOML ../Cargo.toml).package;
in
  pkgs.rustPlatform.buildRustPackage {
    pname = manifest.name;
    version = manifest.version;
    cargoLock.lockFile = ../Cargo.lock;
    src = lib.fileset.unions [
      ../src
      ../Cargo.lock
      ../Cargo.toml
    ];
    meta.mainProgram = "matugen";
  }
