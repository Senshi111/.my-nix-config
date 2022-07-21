
#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, inputs, user, location, ... }:

{
   imports =                                 # Import window or display manager.
     [
#       (import ../modules/services/flameshot.nix)
       (import ../modules/shell/zsh.nix)             # ! Comment this out on first install !
#       (import ../modules/shell/git.nix)             # ! Comment this out on first install !
     ];
  
  users.users.${user} = {                   # System User
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" ];
    shell = pkgs.zsh;                       # Default shell
  };
#   security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.
  virtualisation.libvirtd.enable = true;
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
      usbimager
      kazam           
      ark
      unrar
      unzip
      wget
      curl
      vlc
      azuredatastudio
      slack
      skypeforlinux
      teams
#      viber
      screenfetch
      krusader
      discord
      gimp
      vscode
      gnome.seahorse
      libsecret
      vim
      git
      killall
      nano
      firefox
      google-chrome
      librewolf
      librewolf-wayland
      brave
      virt-manager
      gparted
      oh-my-zsh
      zsh
      gh
      kwrited
      kate
      flameshot
#      pciutils
#      usbutils
      wget
      vulkan-tools
      lutris
    ];
  };

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
