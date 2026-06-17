{ ... }:

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

      shape = [
        {
          monitor = "";
          size = "84,84";
          rounding = -1;
          color = "rgba(49,50,68,0.45)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.30)";
          position = "0,30";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          size = "360,60";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(255,255,255,0.08)";
          position = "0,-165";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          size = "64,64";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "-120,90";
          halign = "center";
          valign = "bottom";
        }

        {
          monitor = "";
          size = "64,64";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "0,90";
          halign = "center";
          valign = "bottom";
        }

        {
          monitor = "";
          size = "64,64";
          rounding = -1;
          color = "rgba(49,50,68,0.55)";
          border_size = 1;
          border_color = "rgba(53,132,228,0.35)";
          position = "120,90";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(255,255,255,1)";
          font_family = "Inter";
          font_size = 96;
          position = "0,280";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%A')\"";
          color = "rgba(186,194,222,0.95)";
          font_family = "Inter";
          font_size = 24;
          position = "0,200";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +'%d %B %Y')\"";
          color = "rgba(186,194,222,0.75)";
          font_family = "Inter";
          font_size = 18;
          position = "0,168";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "";
          color = "rgb(53,132,228)";
          font_size = 42;
          position = "0,30";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "$USER";
          color = "rgba(255,255,255,0.96)";
          font_family = "Inter";
          font_size = 18;
          position = "0,-165";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "󰤄";
          color = "rgb(53,132,228)";
          font_size = 30;
          onclick = "systemctl suspend";
          position = "-120,105";
          halign = "center";
          valign = "bottom";
        }

        {
          monitor = "";
          text = "󰜉";
          color = "rgb(53,132,228)";
          font_size = 30;
          onclick = "reboot";
          position = "0,105";
          halign = "center";
          valign = "bottom";
        }

        {
          monitor = "";
          text = "󰐥";
          color = "rgb(53,132,228)";
          font_size = 30;
          onclick = "poweroff";
          position = "120,105";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = [{
        monitor = "";
        size = "360,60";
        outline_thickness = 2;
        outer_color = "rgb(53,132,228)";
        inner_color = "rgba(49,50,68,0.60)";
        font_color = "rgb(255,255,255)";
        placeholder_text = "󰌾 Password";
        dots_center = true;
        dots_size = 0.22;
        dots_spacing = 0.28;
        fade_on_empty = false;
        font_family = "Inter";
        position = "0,-245";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
