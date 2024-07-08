{
  description = "My home manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; # If you will use this, make sure that home-manager is also pinned to a release

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github.com:nix-community/home-manager/release-24.05"; # If you will use this, make sure that nixpkgs is also pinned to a release
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      # TODO: Update the following line if this fork gets merged
      url = "git+ssh://git@github.com/ys5g/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
      # Is this needed?
      inputs.ndg.follows = "";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    homeConfigurations.yourUserNameGoesHere = home-manager.lib.homeManagerConfiguration {
      # Switch out x86_64-linux for your system
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = {inherit inputs;};

      modules = [
        ./withSpecializations.nix # most people would like this
        # ./withoutSpecializations.nix

        ({
          inputs,
          config,
          ...
        }: {
          imports = [inputs.matugen.homeManagerModules.default];
          home = {
            username = "yourUserNameGoesHere";
            homeDirectory = "/home/${config.home.username}";
            # If you pinned nixpkgs and home-manager to a release, put that here
            #
            # Otherwise, if you're using nixos-unstable and master for nixpkgs
            # and home-manager respectively, make this the next version of nixos
            # (As of July 2024, this is 24.11)
            stateVersion = "24.05";
            # Switch out x86_64-linux for your system
            packages = [inputs.matugen.packages.x86_64-linux.default];
          };
        })
      ];
    };
  };
}
