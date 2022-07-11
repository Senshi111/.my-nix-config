{
  description = "My flake config";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages

      nur = {
        url = "github:nix-community/NUR";                                   # NUR packages
      };

      nixgl = {                                                             #OpenGL
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, nur, nixgl, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      user = "tribal";
      location = "$HOME/.my-nix-config";
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nur user;
        }
      );

    };
}
