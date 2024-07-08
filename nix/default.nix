{
  pkgs,
  lib,
  help2man,
}: let
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

    buildInputs = [help2man];

    postInstall = ''
      mkdir -p $out/share/man

      help2man --no-info ./your-program -o matugen.1
      cp matugen.1 $out/share/man/man1
    '';

    meta.mainProgram = "matugen";
  }
