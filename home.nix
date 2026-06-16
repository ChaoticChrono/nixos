{ config, pkgs, inputs, ... }:
{
  imports = [
  ];
  home.username = "ved";
  home.homeDirectory = "/home/ved";
  home.stateVersion = "26.05";
  home.sessionVariables = {
   GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only";
   };
   home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;

    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
   dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
    };
  };
   gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
   };
  qt = {
    enable = true;
    style = {
    name = "kvantum";
    };
  };
programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.ved = { # Creates a Firefox profile named 'ved'
      name = "ved";
      isDefault = true;
      extensions.force = true;
      # Inject required configuration entries inside user.js
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Allow userChrome.css
        "browser.newtabpage.activity-stream.logowordmark.alwaysVisible" = false;
        "browser.newtabpage.activity-stream.nova.enabled" = false;
         "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
   home.packages = with pkgs; [
   kdePackages.qtstyleplugin-kvantum
   overskride
   pwvucontrol
   hyprpaper
   hyprpolkitagent
   morewaita-icon-theme
   adwaita-icon-theme
   ];
   programs.fish = { 
   enable = true;
   };
   programs.wofi = {
   enable = true;
     settings = {
     allow_images = true;
     show = "drun";
    };
   };
   programs.btop.enable = true;
   programs.fastfetch.enable = true;
   programs.kitty.enable = true;
   wayland.windowManager.hyprland.systemd.enable = false;
   programs.waybar = {
   enable = true;

   settings.mainBar = {
    layer = "top";
    position = "top";
    height = 34;
    spacing = 4;

    modules-left = [
      "hyprland/workspaces"
    ];

    modules-center = [
      "hyprland/window"
    ];

    modules-right = [
      "pulseaudio"
      "network"
      "battery"
      "clock"
      "tray"
    ];

    "hyprland/window" = {
      max-length = 60;
      separate-outputs = true;
    };

    clock = {
      format = "󰃰 {:%a %d %b  %H:%M}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
    };

    network = {
      format-wifi = "󰖩 ";
      format-ethernet = "󰈀 ";
      format-disconnected = "󰖪 ";
      tooltip-format = "{essid}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 ";
      on-click = "pwvucontrol";

      format-icons = {
        default = [ "󰕿" "󰖀" "󰕾 " ];
      };
    };

    battery = {
      format = "󰁹 {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-full = "󰁹 100%";
    };

    tray = {
      spacing = 10;
    };
  };

  style = ''
    * {
      border: none;
      border-radius: 0;
      font-family: Inter, "Symbols Nerd Font Mono";
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background: rgba(30, 30, 30, 0.92);
      color: #ffffff;
    }

    #workspaces {
      margin: 0 8px;
    }

    #workspaces button {
      padding: 0 10px;
      margin: 4px 2px;
      border-radius: 8px;
      color: #cdd6f4;
      background: transparent;
    }

    #workspaces button.active {
      background: #3584e4;
      color: white;
    }

    #workspaces button:hover {
      background: rgba(255,255,255,0.08);
    }

    #window {
      color: #d8dee9;
    }

    #clock,
    #battery,
    #network,
    #pulseaudio,
    #tray {
      padding: 0 12px;
      margin: 4px 4px;
      border-radius: 8px;
      background: rgba(255,255,255,0.05);
    }

    tooltip {
      background: #1e1e1e;
      border-radius: 10px;
      }
    '';
  };
   programs.git = {
     enable = true;
     settings = {
       user = {
         name = "Vedanta Singh";
         email = "ChaoticChrono@proton.me";
               };
  init.defaultBranch = "main";
  alias = {
      ac = "!f() { git add . && git commit -m \"$1\"; }; f";
      acp = "!f() { git add . && git commit -m \"$1\" && git push; }; f";
      flup = "!git diff --quiet && git diff --cached --quiet || (git add . && git commit -m \"Flake Update\" && git push)";
    };
  };
};

fonts.fontconfig.enable = true;
}
