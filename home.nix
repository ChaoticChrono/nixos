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


  xdg.configFile."wayle/config.toml".text = ''
    imports = []

    [general]
    font-sans = "Inter"
    font-mono = "Intel One Mono"
    tearing-mode = false

    [bar]
    scale = 1.0
    inset-edge = 0.0
    inset-ends = 0.0
    padding = 0.35
    padding-ends = 0.5
    module-gap = 0.5
    location = "top"
    exclusive = true
    layer = "top"
    bg = "bg-surface"
    background-opacity = 100
    border-location = "none"
    border-width = 1
    border-color = "border-accent"
    rounding = "sm"
    shadow = "none"
    button-variant = "block-prefix"
    button-opacity = 100
    button-bg-opacity = 100
    button-icon-size = 1.0
    button-icon-padding = 1.0
    button-label-size = 1.0
    button-label-weight = "semibold"
    button-label-padding = 1.0
    button-rounding = "sm"
    button-gap = 1.0
    button-icon-position = "start"
    button-border-location = "all"
    button-border-width = 1
    button-group-border-location = "none"
    button-group-border-width = 1
    button-group-padding = 0.0
    button-group-module-gap = 0.25
    button-group-background = "bg-elevated"
    button-group-opacity = 100
    button-group-border-color = "border-accent"
    button-group-rounding = "sm"
    dropdown-shadow = true
    dropdown-opacity = 100
    dropdown-autohide = true
    dropdown-freeze-label = true

    [[bar.layout]]
    monitor = "*"
    show = true
    left = ["hyprland-workspaces"]
    center = ["window-title"]
    right = [
      "media",
      "notifications",
      "systray",
      "network",
      "bluetooth",
      "brightness",
      "volume",
      "battery",
      "clock",
    ]

    [styling]
    scale = 1.01
    rounding = "sm"
    theme-provider = "wayle"
    theming-monitor = ""
    matugen-scheme = "tonal-spot"
    matugen-contrast = 0.0
    matugen-source-color = 0
    matugen-light = false
    wallust-palette = "dark16"
    wallust-saturation = 0
    wallust-check-contrast = true
    wallust-backend = "fastresize"
    wallust-colorspace = "labmixed"
    wallust-apply-globally = true
    pywal-saturation = 0.05
    pywal-contrast = 3.0
    pywal-light = false
    pywal-apply-globally = true

    [styling.palette]
    bg = "#141420"
    surface = "#1c1c2c"
    elevated = "#262638"
    fg = "#d4d6e8"
    fg-muted = "#8a8ca4"
    primary = "#e0947a"
    red = "#e46870"
    yellow = "#e0b870"
    green = "#68c898"
    blue = "#78a0e0"

    [modules]
    custom = []

    [modules.hyprland-workspaces]
    min-workspace-count = 0
    monitor-specific = true
    show-special = true
    urgent-show = true
    urgent-mode = "workspace"
    display-mode = "label"
    label-use-name = false
    numbering = "absolute"
    divider = " "
    app-icons-show = false
    app-icons-dedupe = true
    app-icons-fallback = "ld-app-window-symbolic"
    app-icons-empty = "tb-minus-symbolic"
    icon-gap = 0.3
    workspace-padding = 0.5
    icon-size = 1.0
    label-size = 1.0
    workspace-ignore = []
    active-indicator = "background"
    active-color = "accent"
    occupied-color = "fg-muted"
    empty-color = "fg-subtle"
    container-bg-color = "bg-surface-elevated"
    border-show = false
    border-color = "border-default"
    left-click = ""
    middle-click = ""
    right-click = ""
    scroll-up = ""
    scroll-down = ""

    [modules.window-title]
    format = "{{ title }}"
    icon-name = "ld-app-window-symbolic"
    border-show = false
    border-color = "blue"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "blue"
    label-show = true
    label-color = "blue"
    label-max-length = 50
    button-bg-color = "bg-surface-elevated"
    left-click = ""
    right-click = ""
    middle-click = ""
    scroll-up = ""
    scroll-down = ""

    [modules.media]
    icon-type = "application-mapped"
    players-ignored = []
    player-priority = []
    format = "{{ title }} - {{ artist }}"
    icon-name = "ld-music-symbolic"
    spinning-disc-icon = "ld-disc-3-symbolic"
    border-show = false
    border-color = "blue"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "blue"
    label-show = true
    label-color = "blue"
    label-max-length = 35
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:media"
    right-click = ""
    middle-click = ""
    scroll-up = ""
    scroll-down = ""

    [modules.notifications]
    icon-name = "ld-bell-symbolic"
    icon-unread = "ld-bell-dot-symbolic"
    icon-dnd = "ld-bell-off-symbolic"
    border-show = false
    border-color = "green"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "green"
    label-show = true
    label-color = "green"
    label-max-length = 0
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:notification"
    right-click = "wayle notify dnd"
    middle-click = ""
    scroll-up = ""
    scroll-down = ""
    blocklist = []
    icon-source = "automatic"
    popup-position = "top-right"
    popup-max-visible = 5
    popup-stacking-order = "newest-first"
    popup-duration = 5000
    popup-hover-pause = true
    popup-margin-x = 0.0
    popup-margin-y = 0.0
    popup-gap = 8.0
    popup-monitor = "primary"
    popup-layer = "overlay"
    popup-close-behavior = "dismiss"
    popup-shadow = true
    popup-urgency-bar = "low"
    thresholds = []

    [modules.systray]
    icon-scale = 1.0
    item-gap = 0.25
    internal-padding = 0.5
    blacklist = []
    overrides = []
    border-show = false
    border-color = "border-accent"
    button-bg-color = "bg-surface-elevated"

    [modules.network]
    wifi-disabled-icon = "cm-wireless-disabled-symbolic"
    wifi-acquiring-icon = "cm-wireless-acquiring-symbolic"
    wifi-offline-icon = "cm-wireless-offline-symbolic"
    wifi-connected-icon = "cm-wireless-connected-symbolic"
    wifi-signal-icons = [
      "cm-wireless-signal-weak-symbolic",
      "cm-wireless-signal-ok-symbolic",
      "cm-wireless-signal-good-symbolic",
      "cm-wireless-signal-excellent-symbolic",
    ]
    wired-connected-icon = "cm-wired-symbolic"
    wired-acquiring-icon = "cm-wired-acquiring-symbolic"
    wired-disconnected-icon = "cm-wired-disconnected-symbolic"
    border-show = false
    border-color = "accent"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "accent"
    label-show = true
    label-color = "accent"
    label-max-length = 15
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:network"
    right-click = ""
    middle-click = ""
    scroll-up = ""
    scroll-down = ""

    [modules.bluetooth]
    disabled-icon = "ld-bluetooth-off-symbolic"
    disconnected-icon = "ld-bluetooth-symbolic"
    connected-icon = "ld-bluetooth-connected-symbolic"
    searching-icon = "ld-bluetooth-searching-symbolic"
    border-show = false
    border-color = "blue"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "blue"
    label-show = true
    label-color = "blue"
    label-max-length = 15
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:bluetooth"
    right-click = ""
    middle-click = ""
    scroll-up = ""
    scroll-down = ""

    [modules.brightness]
    level-icons = [
      "ld-sun-dim-symbolic",
      "ld-sun-medium-symbolic",
      "ld-sun-symbolic",
    ]
    border-show = false
    border-color = "yellow"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "yellow"
    label-show = true
    label-color = "yellow"
    format = "{{ percent }}%"
    label-max-length = 0
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:brightness"
    right-click = ""
    middle-click = ""
    scroll-up = ""
    scroll-down = ""
    thresholds = []

    [modules.volume]
    level-icons = [
      "ld-volume-symbolic",
      "ld-volume-1-symbolic",
      "ld-volume-2-symbolic",
    ]
    icon-muted = "ld-volume-x-symbolic"
    border-show = false
    border-color = "red"
    icon-show = true
    icon-color = "auto"
    icon-bg-color = "red"
    label-show = true
    label-color = "red"
    format = "{{ percent }}%"
    label-max-length = 0
    button-bg-color = "bg-surface-elevated"
    left-click = "dropdown:audio"
    right-click = ""
    middle-click = "wayle audio output-mute"
    scroll-up = ""
    scroll-down = ""
    dropdown-app-icons = "mapped"
    thresholds = []

    [modules.battery]
    level-icons = [
      "md-battery_android_0-symbolic",
      "md-battery_android_frame_1-symbolic",
      "md-battery_android_frame_2-symbolic",
      "md-battery_android_frame_3-symbolic",
      "md-battery_android_frame_4-symbolic",
      "md-battery_android_frame_5-symbolic",
      "md-battery_android_frame_6-symbolic",
      "md-battery_android_frame_full-symbolic",
    ]
      charging-icon = "md-battery_android_frame_bolt-symbolic"
      alert-icon = "md-battery_android_alert-symbolic"
      border-show = false
      border-color = "yellow"
      icon-show = true
      icon-color = "auto"
      icon-bg-color = "yellow"
      label-show = true
      label-color = "yellow"
      format = "{{ percent }}%"
      label-max-length = 0
      button-bg-color = "bg-surface-elevated"
      left-click = "dropdown:battery"
      right-click = ""
      middle-click = ""
      scroll-up = ""
      scroll-down = ""
      thresholds = []

      [modules.clock]
      format = "%a %b %d %I:%M %p"
      icon-name = "tb-calendar-time-symbolic"
      border-show = false
      border-color = "border-accent"
      icon-show = true
      icon-color = "auto"
      icon-bg-color = "accent"
      label-show = true
      label-color = "accent"
      label-max-length = 0
      button-bg-color = "bg-surface-elevated"
      left-click = "dropdown:calendar"
      right-click = "dropdown:weather"
      middle-click = ""
      scroll-up = ""
      scroll-down = ""
      dropdown-show-seconds = false

      [osd]
      enabled = true
      position = "bottom"
      duration = 2500
      monitor = "primary"
      margin = 150.0
      border = true
      layer = "overlay"

      [wallpaper]
      engine-enabled = true
      transition-type = "simple"
      transition-duration = 0.7
      transition-fps = 60
      cycling-enabled = false
      cycling-directory = ""
      cycling-mode = "sequential"
      cycling-interval-mins = 15
      cycling-same-image = false
      monitors = []
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
fonts.fontconfig.enable = true;
}
