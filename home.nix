{ config, pkgs, inputs, ... }:
{
  home.username = "ved";
  home.homeDirectory = "/home/ved";
  home.stateVersion = "26.05";
  home.sessionVariables = {
   GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only";
   };
  # Universal cursor settings
  #home.pointerCursor = {
  #  gtk.enable = true;
  #  x11.enable = true;
  #  size = 32;
  #  name = "Adwaita";
  #  package = pkgs.adwaita-icon-theme;

  #};
  gtk = {
  enable = true;
  #font.name = "Adwaita Sans";
  #font.package = pkgs.adwaita-fonts;
  # theme = {
  #  name = "adw-gtk3-dark";
  #  package = pkgs.adw-gtk3;
  #};
  gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; }; 
  };
  qt = {
    enable = true;
  };
  # Set dconf properties to enforce the Teal scheme for GNOME Shell & Flatpaks
 # dconf.settings = {
 #   "org/gnome/desktop/interface" = {
 #     color-scheme = "prefer-dark";
 #     accent-color = "teal";
 #   };
 #   "org/gnome/desktop/background" = {
      # Nix will automatically convert these paths to file:// absolute URIs in the store
 #     picture-uri = "file://${./wallpaper.webp}";
 #     picture-uri-dark = "file://${./wallpaper.webp}";
 #     picture-options = "zoom";
 #   };
 #   "org/gnome/desktop/screensaver" = {
 #     picture-uri = "file://${./wallpaper.webp}";
 #     picture-options = "zoom";
 #   };
 # };
home.file.".config/mozilla/firefox/ved/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
programs.firefox = {
    enable = true;
    #configPath = ".mozilla/firefox";
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = with pkgs; [
    gnome-browser-connector
    ];
    profiles.ved = { # Creates a Firefox profile named 'ved'
      name = "ved";
      isDefault = true;
      extensions.force = true;
      # Inject required configuration entries inside user.js
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Allow userChrome.css
        "browser.uidensity" = 0;                                       # Normal density for Libadwaita
        "svg.context-properties.content.enabled" = true;               # Correct icon rendering
        "browser.theme.dark-private-windows" = false;                  # Keep GNOME dark theme stable
        "gnomeTheme.hideSingleTab" = true;
        "browser.newtabpage.activity-stream.logowordmark.alwaysVisible" = false;
        "browser.newtabpage.activity-stream.nova.enabled" = false;
      };
      # Import the CSS bindings tracking the fetched repository path
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
    };
  };
  #programs.gnome-shell = {
  #enable = true;
  #extensions = [ 
  #{ package = pkgs.gnomeExtensions.appindicator; }
  #{ package = pkgs.gnomeExtensions.rounded-corners; }
  #{ package = pkgs.gnomeExtensions.overview-background; }
  #{ package = pkgs.gnomeExtensions.adw-gtk3-colorizer; } 
  #{ package = pkgs.gnomeExtensions.rounded-window-corners-reborn; }
  #{ package = pkgs.gnomeExtensions.accent-directories; }
  #{ package = pkgs.gnomeExtensions.tailscale-status; }
  # ];
  #};
   programs.fish.enable = true;
   programs.btop.enable = true;
   programs.fastfetch.enable = true;
   programs.ghostty = {
    enable = true;
    settings = {
      "bold-is-bright" = true;
       background-opacity = 0.95;
       font-family = "Adwaita Mono";
       theme = "Adwaita Dark";
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
#xdg.portal.config = {
#  common = {
#    default = [
#      "gnome"
#      "gtk"
#    ];
#  };
#"org.freedesktop.impl.portal.Secret" = [
#      "gnome-keyring"
#    ];
#};
fonts.fontconfig.enable = true;
}
