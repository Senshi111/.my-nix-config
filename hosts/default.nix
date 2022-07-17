 
#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./desktop OR ./laptop OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix
#

{ lib, inputs, nixpkgs, nur, user, ... }:

let
  system = "x86_64-linux";                             	    # System architecture

  overlayModule =
    {
      nixpkgs.config.allowUnfree = true;                    # Allow proprietary software
      nixpkgs.overlays = [
        (import ./overlays.nix)
      ];
  };
  lib = nixpkgs.lib;
in
{
  desktop = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user ; };                # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      ./desktop
      ./configuration.nix
      overlayModule
    ];
  };

  laptop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = { inherit inputs user ;  };
    modules = [
      nur.nixosModules.nur
      ./laptop
      ./configuration.nix
      overlayModule
    ];
  };
}
