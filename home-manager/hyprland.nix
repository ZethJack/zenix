{pkgs, lib, config, inputs, osConfig, ...}:

  let
    startupScrtipt = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &

      ${pkgs.nm-applet}/bin/nm-applet --indicator &
      ${pkgs.dunst}/bin/dunst &
      ${pkgs.bash}/bin/bash ${~/.local/bin/pwsinks} &
      ${pkgs.qpwgraph}/bin/qpwgraph -am &
      systemctl --user import-environment PATH &
      systemctl --user restart xdg-desktop-portal.service &

      sleep 2
      ${pkgs.swww}/bin/swww init &
      ${pkgs.swww}/bin/swww img ${~/Pics/wall.jpg} &
  in {
    # imports = [];

    options = {
      hyprlandExtra = lib.mkOption {
        default = "";
        description = ''
          extra hyprland config lines
        '';
      };
    };

    config = {
      myHomeManager.waybar.enable = lib.mkDefault true;
      myHomeManager.xremap.enable = lib.mkDefault true;

      wayland.windowManager.hyprland {
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        enable = true;
        # enableNvidiaPatches = true;
        settings = {
          general = {
            gaps_in = 1;
            gaps_out = 2;
            border_size = 1;
            "col.active_border" = "rgba(${config.colorScheme.colors.base0E}ff) rgba(${config.colorScheme.colors.base09}ff)";
            "col.active_border" = "rgba(${config.colorScheme.colors.base00}ff)";

            layout = "master";
          };
          env = [
            "XCURSOR_SIZE,25"
          ];

          input = {
            kb_layout = "cz,us";
            kb_variant = "";
            kb_model = "";
            kb_options = "grp:alt_shift_toggle";

            kb_rules = "";

            follow-mouse = 1;

            repeat_rate = 40;
            repeat_delay = 250;
            force_no_accel = true;

            sensitivity = 0.0
          };

          misc = {
            enable_swallow = true;
            force_default_wallpaper = 0;
          };

          
          decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            blur = {
              enabled = true
              size = 3
              passes = 1
              new_optimizations = true
            };

            rounding = 1

            drop_shadow = true
            shadow_range = 4
            shadow_render_power = 3
            "col.shadow" = "rgba(1a1a1aee)";
          };
        };
      };
    };
  };
