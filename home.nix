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
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  xdg.configFile = {
  "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  "hypr/hypridle.conf".source = ./hypr/hypridle.conf;
  "hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
  };
  services.mako = {
  enable = true;

  settings = {
    anchor = "top-right";
    default-timeout = 5000;

    font = "Inter 10";

    width = 350;
    height = 150;

    margin = "20";
    padding = "12";

    border-size = 2;
    border-radius = 12;

    background-color = "#1e1e2e";
    text-color = "#cdd6f4";
    border-color = "#89b4fa";

    icons = true;
    max-icon-size = 48;

    layer = "overlay";
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
   playerctl
   hyprshutdown
   networkmanagerapplet
   inputs.elyprismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
   xdg-terminal-exec
   wl-clipboard
   yt-dlp
   aria2
   azahar
   waydroid-helper
   libreoffice
   celeste
   btrfs-assistant
   telegram-desktop
   nur.repos.milahu.spotify-adblock
   libnotify
   ];
   programs.fish = { 
   enable = true;
   loginShellInit = ''
    if uwsm check may-start
      exec uwsm start hyprland.desktop
    end
   '';
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
   programs.kitty = {
   enable = true;
   font = {
    name = "Intel One Mono";
    size = 12;
  };
   settings = {
    background_opacity = "0.85";
    };
  };
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
      "mpris"
      "hyprland/window"
    ];

    modules-right = [
      "pulseaudio"
      "network"
      "power-profiles-daemon"
      "battery"
      "clock"
      "tray"
    ];

    "hyprland/workspaces" = {
      format = "{icon}";
        on-scroll-up =  "hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = \"-1\" }))'";
        on-scroll-down = "hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = \"+1\" }))'";
    };

    "hyprland/window" = {
      max-length = 60;
      separate-outputs = true;
    };

    mpris = {
      format = "{player_icon} {dynamic}";
      format-paused = "󰏤 {dynamic}";

      dynamic-len = 40;
      dynamic-order = [ "title" "artist" ];

      player-icons = {
        default = "󰎈";
        spotify = "󰓇 ";
        firefox = "󰈹 ";
      };

      tooltip-format = "{player}\n{title} - {artist}";

      on-click = "playerctl play-pause";
      on-scroll-up = "playerctl next";
      on-scroll-down = "playerctl previous";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 ";

      on-click = "pwvucontrol";

      format-icons = {
        default = [ "󰕿" "󰖀" "󰕾 " ];
      };
    };

    network = {
      format-wifi = "󰖩 ";
      format-ethernet = "󰈀 ";
      format-disconnected = "󰖪 ";

      tooltip-format-wifi = "{essid}";
      tooltip-format-ethernet = "Ethernet";

      on-click = "nm-connection-editor";
    };

    power-profiles-daemon = {
      format = "{icon}";

      format-icons = {
        performance = "󰓅 ";
        balanced = "󰾅 ";
        power-saver = "󰌪 ";
      };

      on-click = "powerprofilesctl set balanced";
      on-click-right = "powerprofilesctl set performance";
      on-click-middle = "powerprofilesctl set power-saver";
    };

    battery = {
      format = "󰁹 {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-full = "󰁹 100%";
    };

    clock = {
      format = "󰃰 {:%a %d %b %H:%M}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
    };

    tray = {
      spacing = 10;
    };
  };

  style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: Inter, "Symbols Nerd Font Mono";
      font-size: 13px;
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
      background: transparent;
      color: #cdd6f4;
    }

    #workspaces button:hover {
      background: rgba(255,255,255,0.08);
    }

    #workspaces button.active {
      background: #3584e4;
      color: white;
    }

    #window {
      color: #d8dee9;
    }

    #mpris,
    #pulseaudio,
    #network,
    #power-profiles-daemon,
    #battery,
    #clock,
    #tray {
      padding: 0 12px;
      margin: 4px;
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
xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh"; 
fonts.fontconfig.enable = true;
}
