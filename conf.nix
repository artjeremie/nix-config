# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "art"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkbOptions in tty.
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Desktop manager
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
      desktopManager.gnome.enable = true;
    };
  };

  # Remap caps to esc
  services.xserver.xkbOptions = "caps:escape";
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    hoaxdream = {
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # Steam
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: nvidia-auto-select +2560+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  # Env variables
  environment = {
    variables = {
      CLUTTER_DEFAULT_FPS = "144";
      __GL_SYNC_DISPLAY_DEVICE = "DP-2";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    firefox
    emacs
    git
  ];

  # Steam
  programs.steam.enable = true;

  # This value determines the NixOS release from which the default
  system.stateVersion = "22.05";

}

