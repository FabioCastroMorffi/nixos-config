{ self, inputs, ... }: {

flake.nixosModules.desktopConfiguration = 
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      self.nixosModules.thinkpadHardware
      self.nixosModules.niri
      self.nixosModules.nvim
      inputs.home-manager.nixosModules.home-manager
    ];

  # Home manager User
  # home-manager.users.fabio = import ../../home.nix;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.fabio = self.homeModules.homeDesktop;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 8;

  networking.hostName = "nix_tower"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # because flakes are still experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true; #no default dm, maybe smth breaks

  # display manager
  services.displayManager.ly = {
        enable = true;
        settings = {
            animation = "gameoflife";
            animation_frame_delay = 15;
            # gameoflife_entropy_interval = 10;
            blank_password = true; # reset password on missed attempt
            bigclock = "en";
            hide_borders = true;
        };
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Fonts
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "esc";
            esc = "capslock";
          };
          otherlayer = {};
        };
      #extraConfig = '';
      };
    };
  };

  # Increase cursor height
  # environment.variables.XCURSOR_SIZE = "132";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Battery
  services.upower.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."guest" = {
    isNormalUser = true;
    initialPassword = "helloworld";
    description = "To try this config out";
    extraGroups = ["networkmanager" "wheel"];
  };

  users.users."fabio" = {
    isNormalUser = true;
    description = "fabio";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  #Sudo Config
  security.sudo = {
    wheelNeedsPassword = false;
  };

  #Bluetooth
  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;
  #   settings = {
  #     General = {
  #       Name = "Computer";
  #       ControllerMode = "dual";
  #       FastConnectable = "true";
  #       Experimental = "true";
  #       Enable = "Source,Sink,Media,Socket";
  #     };
  #     Policy = { AutoEnable = "true"; };
  #     LE = { EnableAdvMonInterleaveScan = "true"; };
  #   };
  # };

  # Install firefox.
  programs.firefox.enable = true;
  programs.git.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	"copilot.vim"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     kitty
     chezmoi
     rmpc
     evolution
     discord
     wine
     curl
     ripgrep
     fd
     gcc
     nodejs_24
     tree
     github-copilot-cli
     fastfetch
     ddrescue
     localsend
     xwayland-satellite
     fuzzel
     noctalia-shell
     jc
     cargo
     rustup
     illum
     bibata-cursors
     gemini-cli
     gnumake
  ];

  #Cusor
  # environment.sessionVariables = {
  #       XCURSOR_THEME = "Bibata-Modern-Classic";
  #       XCURSOR_SIZE = "40";
  # };

  # Default text editor
  programs.neovim.defaultEditor = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # ibus
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
          anthy
      ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  programs.nix-ld.enable = true;
 };
}
