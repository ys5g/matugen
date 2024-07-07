{
  lib,
  mkBoolOpt,
}:
with lib; let
  specs.templates = mkOption {
    type =
      types.attrsOf (types.submodule {
        options = {
          input_path = mkOption {
            type = types.path;
            description = "Path to the template or the template itself as a string";
            example = ./style.css;
          };
          output_path = mkOption {
            type = types.coercedTo types.str builtins.toPath types.path;
            description = "Path where the generated file will be written to";
            example = "builtins.toPath \"\${config.homeDirectory}/.config/style.css\"";
          };
        };
      })
      // {type.description = "Matugen templates";};
    default = {};
    description = "Matugen templates";
  };
  # appList = submodule { options = {
  #
  # }; };
  #   pub struct Config {
  #     pub reload_apps: Option<bool>,
  #     pub version_check: Option<bool>,
  #     pub reload_apps_list: Option<Apps>,
  #     pub set_wallpaper: Option<bool>,
  #     pub wallpaper_tool: Option<WallpaperTool>,
  #     pub swww_options: Option<Vec<String>>,
  #     pub feh_options: Option<Vec<String>>,
  #     pub custom_keywords: Option<HashMap<String, String>>,
  #     pub custom_colors: Option<HashMap<String, CustomColor>>,
  # }
  specs.config = mkOption {
    type = types.submodule {
      options = {
        reloadApps = mkBoolOpt "Whether to reload apps";
        versionCheck = mkEnableOption "the version-checking feature";
        reload_apps_list = mkOption {type = types.attrsOf types.bool;};
        set_wallpaper = mkEnableOption "the wallpaper setting feature";
        wallpaper_tool = mkOption {
          type = types.enum ["Swaybg" "Swww" "Nitrogen" "Feh"];
          description = "The wallpaper tool to use";
        };
        swww_options = mkOption {
          type = types.listOf types.str;
          description = "The options to use for Swww";
        };
        feh_options = mkOption {
          type = types.listOf types.str;
          description = "The options to use for Feh";
        };
        custom_keywords = mkOption {type = types.attrsOf types.str;};
        custom_colors = mkOption {type = types.attrs;};
      };
    };
  };
in
  /*
  {
  */
  /*
  mainSpec =
  */
  mkOption {
    type = types.submodule {
      options = {inherit (specs) templates config;};
    };
    default = {
      config = {};
      templates = {};
    };
  }
/*
}
*/

