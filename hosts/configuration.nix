
#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix
#

{ config, lib, pkgs, inputs, user, location, ... }:

{
#   imports =                                 # Import window or display manager.
#     [
#       ../modules/editors/emacs              # ! Comment this out on first install !
#     ];

  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
#   security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  time.timeZone = "Europe/Belgrade";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
    "en_US.UTF-8/UTF-8"
    ];
  };



  security.rtkit.enable = true;
  sound = {                                 # ALSA sound enable
    enable = true;
    mediaKeys = {                           # Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };


  environment = {
    systemPackages = with pkgs; [           # Default packages install system-wide
      discord
      vscode
      gnome.seahorse
      vim
      git
      killall
      nano
      libsForQt5.applet-window-buttons
      lightly-qt
      libsForQt5.discover
#      pciutils
#      usbutils
      wget
    ];
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
        };}
      );
    })
    (final: prev:
     let
      vscode-insider = prev.vscode.override {
        isInsiders = true;
     };
     in
    {
      vscode = vscode-insider.overrideAttrs (oldAttrs: rec {
       src = (builtins.fetchTarball {
       url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
       sha256 = "0dqs12zflrdn9kni5wjag6d3599gnkxhayhcf93pcyw70y3ryi05";
    });
      version = "latest";
    });
   })
  ];

  services = {
  gnome.gnome-keyring.enable = true;
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    openssh = {                             # SSH: secure shell (remote connection to shell of server)
      enable = true;                        # local: $ ssh <user>@<ip>
                                            # public:
                                            #   - port forward 22 TCP to server
                                            #   - in case you want to use the domain name insted of the ip:
                                            #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
                                            #   - connect via ssh <user>@<ip or ssh.domain>
                                            # generating a key:
                                            #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
                                            #   - if ssh-add does not work: $ eval `ssh-agent -s`
      allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)
                                            # connect: $ sftp <user>@<ip/domain>
                                            # commands:
                                            #   - lpwd & pwd = print (local) parent working directory
                                            #   - put/get <filename> = send or receive file
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';                                   # Temporary extra config so ssh will work in guacamole
    };
    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
                                            # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
  };

  xdg.portal = {                            # Required for flatpak
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;               # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
#     autoUpgrade = {                         # Allow auto update
#       enable = true;
#       channel = "https://nixos.org/channels/nixos-unstable";
#     };
    stateVersion = "22.11";
  };
}
