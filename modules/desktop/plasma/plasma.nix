 
#
#  Plasma configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./plasma
#               └─ plasma.nix *
#

{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "us";                              # Keyboard layout & €-sign

      displayManager = {                          # Display Manager
        sddm = {
          enable = true;                          # Wallpaper and gtk theme

          };
        };
        desktopManager = {
          plasma5 = {
            enable = true;
            runUsingSystemd = true;
          };
        };
    };
  };

  programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on sddm

  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    xorg.xev
    xorg.xkill
    xorg.xrandr
    xterm
    libsForQt5.plasma-integration
    libsForQt5.plasma-browser-integration
    libsForQt5.kaccounts-integration
    libsForQt5.kaccounts-providers
    libsForQt5.kio
    libsForQt5.kio-gdrive
    libsForQt5.applet-window-buttons
    lightly-qt
    libsForQt5.discover
  ];
}

