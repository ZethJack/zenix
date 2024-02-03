{pkgs, lib, config, ...}:

  let
    startupScrtipt = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/sh

      sleep 1
      ${pkgs.swww}/bin/swww img ${~/Pics/wall.jpg} &
      ${pkgs.nm-applet}/bin/nm-applet --indicator &
      ${pkgs.dunst}/bin/dunst &
      ${pkgs.bash}/bin/bash ${~/.local/bin/pwsinks} &
      ${pkgs.qpwgraph}/bin/qpwgraph -am &
  in 
  {
    wayland.windowManager.hyprland {
      enable = true;

      settings = {
        exec-once = ''${startupScrtipt}/bin/start'';
      };
    };
  }
