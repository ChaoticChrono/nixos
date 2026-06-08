{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    inputs.eden.nixosModules.default
  ];

  # --- 1. BOOT, SECUREBOOT (LANZABOOTE) & PLYMOUTH ---
  boot.plymouth.enable = true;
  boot.plymouth.theme = "nixos-bgrt";
  boot.plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ]; 
  boot = {
  tmp.useTmpfs = true;
  };
  boot.loader.timeout = 0;
  systemd.services.nix-daemon = {
  environment.TMPDIR = "/var/tmp";
  };
  # Lanzaboote handles systemd-boot overrides nativly
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd.enable = true;
  # --- 2. KERNEL & PERFORMANCE OPTIMIZATIONS ---
  boot.kernelPackages =  pkgs.linuxPackages_cachyos;
   
  # System scheduler optimizations via sched-ext
  services.scx = {
    enable = true;
    scheduler = "scx_rusty"; 
  };

  # Fast compressed RAM swap allocation
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 100;
  };

  # --- 3. NETWORKING & SYSTEM INTERFACES ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  
  services.resolved = {
    enable = true;
    settings.Resolve.DNSSEC = "true";
    settings.Resolve.Domains = [ "~." ];
    settings.Resolve.DNSOverTLS = "true";
    settings.Resolve.FallbackDNS = [ "1.1.1.1" "1.0.0.1" ];
  
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  # Graphical Desktop Rules (Pure GNOME / Wayland)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
  };
  # --- 4. HARDWARE, AUDIO & GRAPHICS ---
  services.printing.enable = false;
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tuned.enable = true;
  services.tuned.settings.daemon = true;
  services.tuned.ppdSupport = true;
  services.tuned.ppdSettings = {
        profiles = {
            balanced = "balanced";
            performance = "throughput-performance";
            power-saver = "powersave";
        };
        battery = {
            balanced = "balanced-battery";
            performance = "balanced";
            power-saver = "laptop-battery-powersave";
        };
        main = {
            default = "balanced";
            battery_detection = true;
        };
     };
  powerManagement.enable = true;
  services.fwupd.enable = true;
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."98-crackling-fix"."context.properties" = {
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 1024;
      "default.clock.max-quantum" = 8192;
    };
    wireplumber.extraConfig."99-crackling-fix" = {
      "api.alsa.period-size" = 1024;
      "api.alsa.headroom" = 8192;
    };
  };

  services.libinput.enable = true;

  # Hybrid NVIDIA Graphics Configurations
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = false;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";   
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # --- 5. DECLARATIVE FLATPAK PACKAGES ---
  services.flatpak = {
    enable = true;
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
    "com.discordapp.Discord" = {
   Context.sockets = [ "wayland" "x11" ];
   Environment = {
    XCURSOR_SIZE = "48";
    XCURSOR_THEME = "Adwaita";
    };
  };
    };
  };

  # --- 6. USER ENVIRONMENT & SHELLS ---
  users.users.ved = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "rtkit" "adbusers" "networkmanager" "video" "audio" "gamemode"];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = "set -g fish_greeting";
  };
 
  programs.starship = {
    enable = true;
    settings.aws.disabled = true;
  };
 
  programs.git.enable = true;
  programs.appimage = { enable = true; binfmt = true; };
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  # Global Dconf Interface Defaults
  programs.dconf = {
    enable = true;
    profiles.gdm.databases = [{
      settings = with lib.gvariant; {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          accent-color = "teal";
        };
      };
    }];
    profiles.user.databases = [
     {
      settings = {
        "org/gnome/mutter" = {
          experimental-features = [
            "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
            "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
            "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
            "autoclose-xwayland" # automatically terminates Xwayland if all relevant X11 clients are gone
          ];
        };
      };
    }
   ];
  };

  # --- 7. CORE PACKAGES MANAGEMENT ---
  environment.systemPackages = with pkgs; [
    # System Essentials
    sbctl
    inputs.elyprismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
    adw-gtk3
    morewaita-icon-theme 
    xdg-terminal-exec
    wl-clipboard
    temurin-bin-25
    aria2
    azahar
    tpm2-tss
    waydroid-helper
    nautilus-python
    android-tools
    libreoffice
    ffmpeg-headless
    ffmpegthumbnailer
    gdk-pixbuf
    libheif.bin
    libheif.out
    libavif
    libjxl
    webp-pixbuf-loader
    celeste
    libxcursor
    yt-dlp
    # GNOME System Styling Tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.rounded-corners
    gnomeExtensions.blur-my-shell
    gnomeExtensions.adw-gtk3-colorizer
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.accent-directories
    gnomeExtensions.tailscale-status
    gnomeExtensions.just-perfection
  ];
  programs.eden = {
    enable = true;
  };
  environment.pathsToLink = [
    "/share/thumbnailers"
    "/share/nautilus-python/extensions"
    "/share/xdg-desktop-portal" 
    "/share/applications"
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-connections gnome-tour gnome-music gnome-maps gnome-system-monitor
    gnome-contacts epiphany geary gnome-calculator yelp gnome-software
    simple-scan cheese gnome-font-viewer gnome-console
  ];

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.temurin-bin-25}";
    NIXOS_OZONE_WL = "1"; # System-wide Wayland rendering enforcer
    LIBVA_DRIVER_NAME = "iHD";
  };

  # --- 8. SECURITY & UTILITIES ---
  services.openssh.enable = false;
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 41641 25565 ];
    allowedTCPPorts = [ 25565 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  # Gaming Acceleration Triggers
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [ adwaita-icon-theme ];
    extraCompatPackages = with pkgs; [ proton-ge-bin proton-cachyos_x86_64_v3 ];
  };

  services.switcherooControl.enable = true;
  services.udev.packages = [ pkgs.switcheroo-control ];

  # --- 9. NIX ENGINE POLICIES ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "ved" ];
    auto-optimise-store = true;
    substituters = [
    "https://cache.nixos-cuda.org"
     ];
    trusted-public-keys = [
    "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
    max-jobs = 1;
  };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  nixpkgs.overlays = [ inputs.eden.overlays.default ];
  system.stateVersion = "26.05";
}
