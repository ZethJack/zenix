# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "zeth";
    homeDirectory = "/home/zeth";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ 
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    aria2
    bibata-cursors
    brave
    cargo
    chezmoi
    clang
    cmake # to compile vterm
    coreutils
    dconf
    emacs
    emacs-all-the-icons-fonts
    emacsPackages.vterm
    exa
    fd
    file
    gawk
    gh
    git
    glow
    gnumake
    gnupg
    gnused
    gnutar
    jq
    lf
    libtool #to compile vterm
    luajit
    luajitPackages.lua-lsp
    mpv
    ncdu
    neovide
    nil #nix LSP
    nmap
    p7zip
    pciutils
    qpwgraph
    ripgrep
    socat
    steam 
    sxiv
    tree
    ueberzug
    unzip
    usbutils
    webcord
    which
    xz
    zathura
    zip

  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Zeth";
    userEmail = "zeth@zethjack.eu";
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Original-Amber";
    iconTheme.name = "GruvboxPlus";
    };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
	  "application/pdf" = [ "zathura.desktop" ];
	  "image/*" = [ "sxiv.desktop" ];
	  "video/png" = [ "mpv.desktop" ];
	  "video/jpg" = [ "mpv.desktop" ];
	  "video/*" = [ "mpv.desktop" ];
  };

  programs.zsh = {
    enable = true;
	enableAutosuggestions = true;
	enableCompletion = true;
  };

  programs.neovim = {
    enable = true;

	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
