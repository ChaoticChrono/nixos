{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [{
        monitor = "";
        path = "/etc/nixos/wallpaper.jxl";
        blur_passes = 4;
        blur_size = 8;
        contrast = 0.92;
        brightness = 0.72;
        noise = 0.015;
        vibrancy = 0.18;
        vibrancy_darkness = 0.2;
      }];

      label = [
       {
          monitor = "";
          text = "󰤄";
          color = "rgb(53,132,228)";
          font_size = 28;
          onclick = "systemctl suspend";
          position = "-90,100";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "󰜉";
          color = "rgb(53,132,228)";
          font_size = 28;
          onclick = "reboot";
          position = "0,100";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "󰐥";
          color = "rgb(53,132,228)";
          font_size = 28;
          onclick = "poweroff";
          position = "90,100";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(255,255,255,1.0)";
          font_size = 96;
          font_family = "Inter";
          position = "0,260";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%A')\"";
          color = "rgba(186,194,222,0.95)";
          font_size = 26;
          font_family = "Inter";
          position = "0,180";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%d %B %Y')\"";
          color = "rgba(186,194,222,0.75)";
          font_size = 18;
          font_family = "Inter";
          position = "0,145";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(255,255,255,0.95)";
          font_size = 18;
          font_family = "Inter";
          position = "0,-70";
          halign = "center";
          valign = "center";
        }
      ];

      shape = [
        {
          monitor = "";
          size = "340,54";
          color = "rgba(49,50,68,0.55)";
          rounding = -1;
          border_size = 1;
          border_color = "rgba(255,255,255,0.08)";
          position = "0,-70";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "58,58";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "-90,100";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          size = "58,58";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "0,100";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          size = "58,58";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "90,100";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = [{
        monitor = "";
        size = "340,60";
        outline_thickness = 2;
        outer_color = "rgb(53,132,228)";
        inner_color = "rgba(49,50,68,0.60)";
        font_color = "rgb(255,255,255)";
        placeholder_text = "<span foreground='#bac2de'>Password</span>";
        dots_center = true;
        dots_size = 0.22;
        dots_spacing = 0.28;
        fade_on_empty = false;
        font_family = "Inter";
        position = "0,-145";
        halign = "center";
        valign = "center";
      }];

    };
  };
}
