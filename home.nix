{ config, pkgs, inputs, ... }:
{
  imports = [
  inputs.brave-origin.homeManagerModules.default
  inputs.walker.homeManagerModules.default
  ];
  home.username = "ved";
  home.homeDirectory = "/home/ved";
  home.stateVersion = "26.05";
  home.sessionVariables = {
   };
   home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;

     package = pkgs.adwaita-icon-theme;
     name = "Adwaita";
     size = 32;
  };
   dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
      gtk-theme = "adw-gtk3-dark";
      font-name = "Inter 12";
      document-font-name = "Inter 12";
      monospace-font-name = "Intel One Mono 12";
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
    font = {
      name = "Inter";
      size = 12;
     };
   };
  qt = {
    enable = true;
    style = {
    name = "kvantum";
    };
  };
  services.hypridle = { 
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
    };

    listener = [
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
    ];
  };
  };
  xdg.configFile = {
  "hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  };
   programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = false;
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
  services.hyprpaper = {
  enable = true;
  settings = {
    preload = [
      "/etc/nixos/wallpaper.jxl"
    ];
    wallpaper = [
      {
        monitor = "";
        path = "/etc/nixos/wallpaper.jxl";
      }
    ];
      splash = false;
  };
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
   programs.brave = {
    enable = true;
    package = inputs.brave-origin.packages.${pkgs.stdenv.hostPlatform.system}.default;

    extensions = [
      "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "mgngbgbhliflggkamjnpdmegbkidiapm" # Remove YouTube Shorts
    ];

    commandLineArgs = [
      "--enable-features=ParallelDownloading"
    ];
  };
   home.packages = with pkgs; [
   kdePackages.qtstyleplugin-kvantum
   grim 
   slurp
   satty
   overskride
   pwvucontrol
   morewaita-icon-theme
   adwaita-icon-theme
   playerctl
   hyprshutdown
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
   snapshot
   nautilus
   sushi
   loupe
   ];
   programs.fish = { 
   enable = true;
   loginShellInit = ''
    if uwsm check may-start
      exec uwsm start hyprland.desktop
    end
   '';
   };
   programs.walker = {
    enable = true;
    runAsService = true;
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
  services.hyprpolkitagent.enable = true;
  services.wayle = {
    enable = true;

    # We provide the config ourselves below.
    settings = { };
  };

  xdg.configFile."wayle/config.toml".text = ''
    imports = []

[general]
font-sans = "Inter"
font-mono = "Intel One Mono"
tearing-mode = false

[styling]
scale = 1
rounding = "sm"
theme-provider = "gtk"

[bar]
scale = 1
height = 24

inset-edge = 0.0
inset-ends = 0.0

padding = 0.10
padding-ends = 0.25
module-gap = 0.20

location = "top"
exclusive = true
layer = "top"

bg = "bg-surface"
background-opacity = 80

border-location = "none"
border-width = 1
border-color = "border-accent"

rounding = "none"
shadow = "none"

button-variant = "block-prefix"

button-opacity = 100
button-bg-opacity = 100

button-icon-size = 0.80
button-label-size = 0.80

button-icon-padding = 0.40
button-label-padding = 0.40

button-label-weight = "semibold"

button-gap = 0.25
button-rounding = "sm"

button-border-location = "all"
button-border-width = 1

button-group-padding = 0.0
button-group-module-gap = 0.15
button-group-rounding = "sm"

dropdown-shadow = true
dropdown-opacity = 100
dropdown-autohide = true
dropdown-freeze-label = true

[[bar.layout]]
monitor = "eDP-1"
show = true

left = [
    "hyprland-workspaces",
    "media",
]

center = [
    "window-title",
]

right = [
    "notifications",
    "systray",
    "network",
    "bluetooth",
    "brightness",
    "volume",
    "battery",
    "clock",
]

[[bar.layout]]
monitor = "HDMI-A-1"
show = true

left = [
    "hyprland-workspaces",
    "media",
]

center = [
    "window-title",
]

right = [
    "notifications",
    "systray",
    "network",
    "bluetooth",
    "brightness",
    "volume",
    "battery",
    "clock",
]

[modules.window-title]
format = "{{ title }}"
icon-show = false
label-show = true
label-max-length = 48

[modules.media]
format = "{{ title }}"
label-max-length = 28

[modules.notifications]
label-show = true

[modules.network]
label-show = false

[modules.bluetooth]
label-show = true

[modules.brightness]
label-show = false

[modules.volume]
label-show = true

[modules.battery]
format = "{{ percent }}%"
label-show = false
[modules.clock]
format = "%a %H:%M"
  '';
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
fonts = {
fontconfig = {
  enable = true;
  defaultFonts = {
    serif = [ "Inter" ];
    sansSerif = [ "Inter" ];
    monospace = [ "Intel One Mono" ];
    emoji = [ "Twitter Color Emoji" ];
  };
};
};
}
