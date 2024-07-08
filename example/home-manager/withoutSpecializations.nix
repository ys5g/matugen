{
  config,
  pkgs,
  ...
}: {
  programs.matugen = {
    enable = true;
    # This must be the path to the wallpaper
    wallpaper = "${pkgs.nixos-artwork.wallpapers.mosaic-blue}/share/backgrounds/nixos/nix-wallpaper-mosaic-blue.png";

    # Remove these 3 lines if you want to use the default(which
    # is "scheme-tonal-spot")
    palette = "scheme-fruit-salad";

    # Default is "dark"
    variant = "light";

    settings = {
      config = {
        reload_apps = true;
        reload_apps_list = {
          dunst = true;
          gtk_theme = true;
        };
        # If you're using specialisations, enabling this would be a good idea
        set_wallpaper = true;
        # This is one of Swaybg, Swww, Nitrogen, or Feh,
        wallpaper_tool = "Swww";
        # If using feh, you can use "feh_options"
        swww_options = ["--transition-type" "center"];
      };
      templates.gtk3 = {
        # If using matugen-themes(https://github.com/InioX/matugen-themes),
        # you can set input_path to "${config.matugen-themes.themes.gtk}"
        input_path = "./templates/gtk.css";
        output_path = "${config.xdg.configHome}/gtk-3.0/gtk.css";
      };
    };
  };
}
