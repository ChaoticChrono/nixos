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
  qt = {
    enable = true;
  };
  wayland.windowManager.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
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

   programs.fish = { 
   enable = true;
   };
   programs.btop.enable = true;
   programs.fastfetch.enable = true;
   programs.kitty.enable = true;
   wayland.windowManager.hyprland.systemd.enable = false;
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
