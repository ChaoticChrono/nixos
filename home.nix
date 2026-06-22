{ config, pkgs, inputs, ... }:
{
  imports = [
  inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  home.username = "ved";
  home.homeDirectory = "/home/ved";
  home.stateVersion = "26.05";
  home.sessionVariables = {
   MOZ_USE_XINPUT2 = "1";
   };
   programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];

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
         "toolkit.tabbox.switchByScrolling" = true;
      };
    };
  };
   programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--enable-features=ParallelDownloading"
    ];
    
  };
   home.packages = with pkgs; [
   inputs.elyprismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
   xdg-terminal-exec
   wl-clipboard
   yt-dlp
   aria2
   azahar
   libreoffice
   celeste
   ffmpeg-full
   btrfs-assistant
   telegram-desktop
   nur.repos.milahu.spotify-adblock
   libnotify
   duf
   zoxide
   usbutils
   ryubing
   eden
   unrar
   ventoy-full-gtk
   ];
   programs.fish = { 
   enable = true;
   shellAliases = {
    sudo = "doas";
   };
   };
   programs.zoxide = { 
    enable = true;
    options = [
     "--cmd cd"
    ];
   };
   programs.eza = {
    enable = true;
    icons = "auto";
   };
 
   programs.btop = { 
   enable = true; 
   package = pkgs.btop-cuda;
   };
   programs.fastfetch.enable = true;
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
services.flatpak = {
    enable = true;
    update.onActivation = true;
    uninstallUnmanaged = true;
    packages = [
      "page.codeberg.M23Snezhok.Vinyl"
      "org.vinegarhq.Sober"
      "io.github.giantpinkrobots.varia"
      "com.usebottles.bottles"
      "com.discordapp.Discord"
    ];
     overrides = {
      global = {
      Context.filesystems = [ "/nix/store:ro" ];
      Context.sockets = [ "wayland" "!x11" ];
      Environment = {
        # Fix un-themed cursor in some Wayland apps
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
      };
    };
    "org.vinegarhq.Sober" = {
        Environment = {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __GLVND_DISALLOW_PATCHING = "1";
        };
      };
    };
  };
}
