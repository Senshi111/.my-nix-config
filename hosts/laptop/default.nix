
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

{ config, pkgs, lib, user, ... }:

{
  imports =                                     # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/plasma/plasma.nix)];   # Window Manager
#    [(import ../../modules/programs/steam.nix)];          # Gaming
#     [(import ../../modules/services/media.nix)] ++        # Media Center
#     (import ../../modules/desktop/virtualisation) ++      # Virtual Machines & VNC
#    (import ../../modules/hardware);                      # Hardware devices

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_lqx;
#    initrd.kernelModules = [ "nvidia" ];        # Video drivers

    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5;                 # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 5;
      
#      grub.enable = true;
#      grub.devices = [ "nodev" ];
#      grub.efiInstallAsRemovable = true;
#      grub.efiSupport = true;
#      grub.useOSProber = true;                               # Grub auto select time
    };
    initrd.checkJournalingFS = false;
  };
  powerManagement.cpuFreqGovernor = "performance"; #"ondemand", "powersave", "performance"
  programs.dconf.enable = true;
  programs.adb.enable = true;
  programs = {                                  # Needed to succesfully start Steam
    steam = {
      enable = true;
      #remotePlay.openFirewall = true;           # Ports for Stream Remote Play
    };
    gamemode.enable = true;                     # Better gaming performance
                                                # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
                                                # Lutris: General Preferences - Enable Feral GameMode
                                                #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
  };
  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.
#      discord
#      plex
#      simple-scan
#      x11vnc
#      wacomtablet
#      vscodium
       (steam.override {
          extraProfile = ''
            unset VK_ICD_FILENAMES
            export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json:$VK_ICD_FILENAMES
           '';
       })
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
