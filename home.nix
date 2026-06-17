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
   grim 
   slurp
   satty
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
   wofi-emoji
   cursor-clip
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
   services.wayle = {
  enable = true;

  settings = {
    imports = [ ];

    general = {
      font-sans = "Inter";
      font-mono = "Intel One Mono";
      tearing-mode = false;
    };

    bar = {
      scale = 1.0;

      location = "top";
      exclusive = true;
      layer = "top";

      inset-edge = 0.0;
      inset-ends = 0.0;

      height = 34;

      padding = 0.35;
      padding-ends = 0.75;

      module-gap = 0.5;

      rounding = "full";

      background-opacity = 95;
      bg = "bg-surface";

      border-location = "none";
      border-width = 1;
      border-color = "border-accent";

      shadow = "lg";

      button-variant = "block-prefix";

      button-opacity = 100;
      button-bg-opacity = 100;

      button-rounding = "full";

      button-gap = 0.75;

      button-icon-size = 1.0;
      button-label-size = 1.0;
      button-label-weight = "semibold";

      button-icon-padding = 1.0;
      button-label-padding = 1.0;

      button-group-rounding = "full";
      button-group-padding = 0.15;
      button-group-module-gap = 0.25;

      button-group-background = "bg-elevated";
      button-group-opacity = 100;
      button-group-border-location = "none";
      button-group-border-width = 1;
      button-group-border-color = "border-accent";

      dropdown-shadow = true;
      dropdown-opacity = 100;
      dropdown-autohide = true;
      dropdown-freeze-label = true;

      layout = [
        {
          monitor = "*";
          show = true;

          left = [
            "dashboard"
            "hyprland-workspaces"
          ];

          center = [
            "window-title"
          ];

          right = [
            "media"
            "notifications"
            "systray"
            "network"
            "bluetooth"
            "brightness"
            "volume"
            "battery"
            "clock"
          ];
        }
      ];
    };

    styling = {
      scale = 1.0;
      rounding = "full";

      # If you use Stylix/GTK, change this to "gtk"
      theme-provider = "wayle";

      palette = {
        bg = "#1e1e2e";
        surface = "#313244";
        elevated = "#45475a";

        fg = "#cdd6f4";
        fg-muted = "#9399b2";

        primary = "#89b4fa";

        red = "#f38ba8";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        blue = "#89b4fa";
      };
    };

    modules = {

      hyprland-workspaces = {
        monitor-specific = true;
        show-special = true;

        display-mode = "label";

        active-indicator = "background";

        workspace-padding = 0.6;

        divider = " ";

        app-icons-show = false;

        border-show = false;
      };

      window-title = {
        format = "{{ title }}";
        label-max-length = 60;
      };

      media = {
        format = "{{ title }} • {{ artist }}";
        label-max-length = 30;
        left-click = "dropdown:media";
      };

      notifications = {
        popup-position = "top-right";
        popup-max-visible = 5;
        popup-duration = 6000;

        left-click = "dropdown:notification";
        right-click = "wayle notify dnd";
      };

      network = {
        left-click = "dropdown:network";
      };

      bluetooth = {
        left-click = "dropdown:bluetooth";
      };

      brightness = {
        format = "{{ percent }}%";
        left-click = "dropdown:brightness";
      };

      volume = {
        format = "{{ percent }}%";
        left-click = "dropdown:audio";
        middle-click = "wayle audio output-mute";
      };

      battery = {
        format = "{{ percent }}%";
        left-click = "dropdown:battery";
      };

      clock = {
        format = "%a %d %b  %H:%M";

        left-click = "dropdown:calendar";
        right-click = "dropdown:weather";
      };

      systray = {
        icon-scale = 1.0;
        item-gap = 0.25;
        internal-padding = 0.5;
      };
    };

    osd = {
      enabled = true;
      position = "bottom";
      duration = 1800;
      monitor = "primary";
      margin = 120.0;
      border = false;
      layer = "overlay";
    };
  };
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
