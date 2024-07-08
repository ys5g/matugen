{ config, pkgs, ... }: {
  programs.matugen = {
    enable = true;
    # Uncomment lines 7-13 and replace keys and values as necessary
    # programs.matugen.wallpapers should contain at least one key
    wallpapers = {
      # would automatically be removed
      # cat = ./wallpapers/cat.jpg;
      # beach = ./wallpapers/beach.png;
      mosaic = "${pkgs.nixos-artwork.wallpapers.mosaic-blue}/share/backgrounds/nixos/nix-wallpaper-mosaic-blue.png";
    };
    # programs.matugen.wallpaper(without the 's' at the end) should be a
    # string that is equal to one of the attribute names in
    # programs.matugen.wallpapers
    wallpaper = "mosaic";

    # Remove these 3 lines if you want to use the default(which 
    # is "scheme-tonal-spot")
    palette = "scheme-fruit-salad";

    # Default is "dark"
    variant = "light";

    useSpecialisations = true;
    
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
        swww_options = [ "--transition-type" "center" ]; 
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
