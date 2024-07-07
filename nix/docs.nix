{
  lib,
  ndg,
  pkgs,
  runCommandLocal,
  self,
  system,
}: let
  mkNdgSiteFrom = options:
    ndg.packages.${system}.ndg-builder.override {
      evaluatedModules.options = options;
      title = "Matugen Home-Manager module Documentation";
    };

  matugenModule = self.homeManagerModules.default;

  evalManipulation.config._module = {
    check = false;
    args = {inherit pkgs;};
  };

  evaluatedModule = {extra ? {}}:
    builtins.removeAttrs
    (lib.evalModules {modules = [matugenModule evalManipulation extra];}).options
    ["_module"];

  docsWithoutS12n = mkNdgSiteFrom (evaluatedModule {});
  docsWithS12n = mkNdgSiteFrom (evaluatedModule {extra.programs.matugen.useSpecialisations = true;});
in
  runCommandLocal "matugenModuleDocs" {allowSubstitutes = false;} "mkdir -p $out; ln -s ${docsWithS12n} $out/withSpecial.html; ln -s ${docsWithoutS12n} $out/index.html;"
