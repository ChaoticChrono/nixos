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
     size = 32;
  };
   dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Morewaita";
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
