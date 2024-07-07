nix-build \
  --expr "{pkgs, flake, manipulateEvaluation}: pkgs.lib.evalModules { modules = [flake.homeManagerModules.matugen]++manipulateEvaluation; }" \
  --arg pkgs "import <nixpkgs> {}" \
  --arg flake 'builtins.getFlake "${toString ./.}"' \
  --arg manipulateEvaluation "[{ config._module = { check = false; args.pkgs = (import <nixpkgs> {}); }; } {programs.matugen.wallpaper = ./README.md;}]" \
  -A options.programs
