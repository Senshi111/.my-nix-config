
#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./bspwm
#       │   │   └─ bspwm.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       ├─ ./programs
#       │   └─ games.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./hardware
#           └─ default.nix
#

{ pkgs, lib, user, ... }:

{
  imports =                                     # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/plasma/plasma.nix)] ++   # Window Manager
    [(import ../../modules/programs/steam.nix)] ++          # Gaming
#     [(import ../../modules/services/media.nix)] ++        # Media Center
#     (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
   (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = [ "nvidia" ];        # Video drivers

    loader = {                                  # For legacy boot:
 #     systemd-boot = {
 #       enable = true;
 #       configurationLimit = 5;                 # Limit the amount of configurations
 #     };
 #     efi.canTouchEfiVariables = true;
 #     timeout = 5;   
 
      grub.enable = true;
      grub.devices = [ "nodev" ];
      grub.efiInstallAsRemovable = true;
      grub.efiSupport = true;
      grub.useOSProber = true;                           # Grub auto select time
    };
  };


  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
#      discord
#      plex
#      simple-scan
#      x11vnc
#      wacomtablet
#      vscodium
    ];
  };

  services = {

    blueman.enable = true;                      # Bluetooth

    xserver = {                                 # In case, multi monitor support
      videoDrivers = [                          # Video Settings
        "nvidia"
      ];

    };
  };
}
