{inputs, ...}: {
  imports = [inputs.matugen.homeManagerModules.default];
  home = {
    # If you pinned nixpkgs and home-manager to a release, put that here
    # 
    # Otherwise, if you're using nixos-unstable and master for nixpkgs
    # and home-manager respectively, make this the next version of nixos
    # (As of July 2024, this is 24.11)
    stateVersion = "24.05"; 
    # Switch out x86_64-linux for your system
    packages = [ inputs.matugen.packages.x86_64-linux.default ];
  };
}
