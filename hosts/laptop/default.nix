
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
#       │   ├─ ./plasma
#       │   │   └─ plasma.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       ├─ ./programs
#       │   └─ steam.nix
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
    [(import ../../modules/programs/steam.nix)];          # Gaming
#     [(import ../../modules/services/media.nix)] ++        # Media Center
#     (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
#    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
#    initrd.kernelModules = [ "nvidia" ];        # Video drivers

    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5;                 # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;                              # Grub auto select time
    };
    initrd.checkJournalingFS = false;
  };

  programs.dconf.enable = true;
  programs.adb.enable = true;

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

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

    # NVIDIA drivers are unfree;
   hardware.nvidia.modesetting.enable = true;
#   services.xserver.videoDrivers = [ "nvidia" ];

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
   hardware.nvidia.prime = {
     offload.enable = true;

     # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
     intelBusId = "PCI:0:2:0";

     # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
     nvidiaBusId = "PCI:1:0:0";
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
