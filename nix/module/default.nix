# `self` is the entire matugen flake
{self}: {
  config,
  lib,
  pkgs,
  ...
}: let
  #############
  # Variables #
  #############
  cfg = config.programs.matugen;

  tomlFormat = pkgs.formats.toml {};

  # This is basically the same as lib.mkEnableOption, but the description of
  # the option is not "Whether to enable xyz"
  mkBoolOpt = arg:
    lib.mkEnableOption ""
    // (
      if (builtins.typeOf arg == "string")
      then {description = arg;}
      else arg
    );

  # Package from this flake
  matugenPkg = self.packages.${pkgs.system}.default;

  # Generated toml configuration file
  cfgFile = tomlFormat.generate "matugen-config.toml" cfg.settings;

  genMatugenEnv = args@{
    wallpaper ? args.currentWallpaperInS12n,
    variant,
    palette,
    ...
  }:
    pkgs.runCommandLocal "${variant}MatugenEnv-${toString wallpaper}" {} ''
      mkdir -p $out

      ${lib.getExe matugenPkg} \
        image ${wallpaper} \
        --config ${cfgFile}
        --quiet \
        --prefix $out \
        --mode ${variant} \
        --type ${palette}
    '';
in {
  #############
  # Interface #
  #############
  options.programs.matugen = with lib; {
    enable = mkEnableOption "matugen";
    package = (mkPackageOption pkgs "matugen" {}) // {default = matugenPkg;};

    wallpaper = mkOption {
      default = null;
      type = types.nullOr (
        if !cfg.useSpecialisations
        then types.path
        else
          (types.enum (builtins.attrValues cfg.wallpapers))
          // {
            description = lib.concatStrings [
              "one of the attribute names of `programs.matugen.wallpapers`"
              " - "
              "e.g: one of `snow`, `car`"
            ];
          }
      );
      description = ''
        The path to the wallpaper that matugen will generate the colorscheme from

        If you are using specialisations, this will be the default wallpaper(i.e.
        the one that is not walled behind a specialisation)
      '';
    };
    wallpapers = mkOption {
      example = {
        snow = "./wallpapers/snow.jpg";
        car = "./wallpapers/car.png";
      };
      default = {};
      type = types.attrsOf types.path;
      description = "Every wallpaper to generate a colorscheme from";

      visible = cfg.useSpecialisations;
    };
    currentWallpaperInS12n = mkOption {
      default = null;
      type = types.nullOr (types.enum (builtins.attrValues cfg.wallpapers));
      description = ''
        The current wallpaper(used internally for the matugen module)
      '';

      internal = true;
      visible = false;
    };

    palette = mkOption {
      description = "Palette used when generating the colorschemes";
      type = types.enum (map (type: "scheme-${type}") [
        "content"
        "expressive"
        "fidelity"
        "fruit-salad"
        "monochrome"
        "neutral"
        "rainbow"
        "tonal-spot"
      ]);
      default = "scheme-tonal-spot";
      example = "scheme-fruit-salad";
    };

    variant = mkOption {
      description = "Colorscheme variant";
      type = types.enum ["light" "dark"];
      default = "dark";
      example = "light";
    };

    # settings = import ./configSubmod.nix { inherit lib mkBoolOpt; };

    settings = mkOption {
      default = {};
      type = tomlFormat.type;
      example = builtins.fromTOML (builtins.readFile ../../example/config.toml);
      description = ''
        Matugen configuration. For help on configuration, see
        <https://github.com/InioX/matugen/wiki/Configuration>
      '';
    };

    useSpecialisations = mkBoolOpt ''
      Whether matugen should generate specialisations from the values of
      config.programs.matugen.specialisations.wallpapers
    '';

    env = mkOption {
      type = types.package;
      default = genMatugenEnv cfg;
      # Hides it from documentation
      visible = false;
      description = "The derivation to extract the populated templates from";
    };
  };

  ##################
  # Implementation #
  ##################
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          # This will fail if config.programs.matugen.wallpaper is not set
          # even though matugen is enabled
          assertion = cfg.wallpaper != null;
          message = "When matugen is enabled, you must set config.programs.matugen.wallpaper to something";
        }
        {
          # This will fail if cfg.useSpecialisations is true but no wallpapers
          # are provided
          assertion = !((cfg.wallpapers == {}) && cfg.useSpecialisations);
          message = ''
            When matugen is set to use specialisations, you must set
            config.programs.matugen.wallpapers
          '';
        }
      ];

      # programs.matugen.env = genMatugenEnv cfg;

      home.packages = with cfg; [package /* env */];

      xdg.configFile = {
        "matugen/config.toml".source = cfgFile;
      };
    }
    (lib.mkIf (builtins.length (builtins.attrNames cfg.wallpapers) > 1) {
      specialisation =
        lib.attrsets.mapAttrs'
        (
          name: _val:
            lib.attrsets.nameValuePair
            # Example output:
            # matugen_car_wallpaper = { ... }
            ("matugen_" + name + "_wallpaper")
            {
              configuration.programs.matugen = {
                # E.g.:     cfg._allColors.car
                currentWallpaperInS12n = lib.mkForce cfg.wallpapers.${name};

                env = lib.mkForce (genMatugenEnv cfg);
              };
            }
        )
        (removeAttrs [cfg.wallpaper] cfg.wallpapers);
    })
  ]);
}
