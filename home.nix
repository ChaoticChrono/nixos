{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  home.username = "ved";
  home.homeDirectory = "/home/ved";
  home.stateVersion = "26.05";
  home.sessionVariables = {
   GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only";
   };
  # Universal cursor settings
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 32;
    name = "breeze_cursors";
    package = pkgs.kdePackages.breeze;
  };
  gtk = {
  theme = {
  enable = true;
  package = pkgs.kdePackages.breeze-gtk;
  name = "Breeze";
  };
  gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; }; 
  };
  qt = {
    enable = true;
  };

programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = with pkgs; [
    kdePackages.plasma-browser-integration
    ];
    preferences = {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    profiles.ved = { # Creates a Firefox profile named 'ved'
      name = "ved";
      isDefault = true;
      extensions.force = true;
      # Inject required configuration entries inside user.js
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Allow userChrome.css
        "browser.newtabpage.activity-stream.logowordmark.alwaysVisible" = false;
        "browser.newtabpage.activity-stream.nova.enabled" = false;
      };
    };
  };

   programs.fish.enable = true;
   programs.btop.enable = true;
   programs.fastfetch.enable = true;
   programs.ghostty = {
    enable = true;
    settings = {
      "bold-is-bright" = true;
       background-opacity = 0.95;
       window-show-tab-bar = "always";
       theme = "Adwaita Dark";
       font-family = "Intel One Mono";
       font-family-fallback = [
       "Symbols Nerd Font Mono"
       "Twitter Color Emoji"
         ];
       font-size = 12;
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
programs.plasma = {
  enable = true;
  
   workspace = {
    wallpaper = ./wallpaper.webp;
   };
   
  fonts = {
    general = {
      family = "Inter";
      pointSize = 11;
    };

    fixedWidth = {
      family = "Intel One Mono";
      pointSize = 12;
    };

    small = {
      family = "Inter";
      pointSize = 10;
    };

    toolbar = {
      family = "Inter";
      pointSize = 11;
    };

    menu = {
      family = "Inter";
      pointSize = 11;
    };

    windowTitle = {
      family = "Clear Sans";
      pointSize = 11;
      weight = "bold";
    };
  };
   
  configFile = {

    kwinrc.Plugins.blurEnabled = true;
    kwinrc.Plugins.translucencyEnabled = true;
    kwinrc.Plugins.wobblywindowsEnabled = true;

    kwinrc.Plugins.dynamic_workspacesEnabled = true;

    kdeglobals.General.accentColorFromWallpaper = true;
    kdeglobals.KDE.contrast = 4;
    kdeglobals.KDE.frameContrast = 0.2;

    kwinrc.Windows.ElectricBorderDelay = 0;

    kwinrc.Xwayland.Scale = 1.25;

    kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "X";
    kwinrc."org.kde.kdecoration2".ButtonsOnRight = "";

  };
};

fonts.fontconfig.enable = true;
}
