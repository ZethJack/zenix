# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../common/greetd.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  # boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  # Set hostname
  networking.hostName = "hashbrown";
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Set time zone and locale
  time.timeZone = "Europe/Prague";
  
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;
  #
  # # nVidia gpu settings
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   # nvidiaPersistenced = true;
  # };
  # Enabling hyprland on nixos
  programs.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  environment.sessionVariables = {
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  # Enable the LXQT Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.lxqt.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "cz";
    xkbVariant = "";
  };

  # Configure console keymap
  console = {
    keyMap = "cz-qwertz";
    font = "Lat2-Terminus16";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable PolicyKit
  security.polkit.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  users.users.zeth = {
    isNormalUser = true;
    description = "Zeth";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      neovim
      vim
      git
      curl
      wget
      (pass.withExtensions (exts: with exts; [
        pass-otp
      ]))
      pass
    #  thunderbird
    ];
  };
  # This setups a SSH server. Very important if you're setting up a headless system.
 #gnupg
 services.pcscd.enable = true;
 services.dbus.packages = [ pkgs.gcr ];
 programs.gnupg.agent = {
   enable = true;
   pinentryFlavor = "gtk2";
   enableSSHSupport = true;
 };
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; #forbid root login through ssh
      PasswordAuthentication = false; # use keys only for ssh
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
