{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    inputs.eden.nixosModules.default
  ];

  # --- 1. BOOT, SECUREBOOT (LANZABOOTE) & PLYMOUTH ---
  boot.plymouth = { 
  enable = true; 
  theme = "nixos-bgrt";
  themePackages = with pkgs; [
  nixos-bgrt-plymouth     
  ];
  };
  boot.kernelParams = [
    "quiet"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"
  ];
  boot = {
  # Enable "Silent boot"
  consoleLogLevel = 3;
  initrd.verbose = false;
  };
  boot.loader.timeout = 0;
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
  boot.kernel.sysctl = {
  # ArchWiki-recommended range for zram-backed systems
  "vm.swappiness" = 133;

  # Better interaction with zram
  "vm.page-cluster" = 0;

  # Keep filesystem metadata cached longer
  "vm.vfs_cache_pressure" = 50;

  # Helps Proton, Wine, Java apps, emulators
  "vm.max_map_count" = 2147483642;

  # Prevent inotify exhaustion
  "fs.inotify.max_user_watches" = 1048576;
  "fs.inotify.max_user_instances" = 1024;
  };
  # Fast compressed RAM swap allocation
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 100;
    priority = 100;
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
    settings.Resolve.FallbackDNS = [ "1.1.1.1#cloudflare-dns.com" "1.0.0.1#cloudflare-dns.com" ];
  
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };
  systemd.user.services.niri.enableDefaultPath = false;
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
  security.polkit.enable = true;
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
  services.upower.enable = true;
  services.libinput.enable = true;
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
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
  programs.hyprland = {
  enable = true;
  withUWSM = true;
  xwayland.enable = true;
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
      "moe.launcher.an-anime-game-launcher"
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
    };
  };
    };
  };

  # --- 6. USER ENVIRONMENT & SHELLS ---
  users.users.ved = {
    isNormalUser = true;
    description = "Vedanta Singh"; 
    shell = pkgs.fish;
    extraGroups = [ "wheel" "rtkit" "adbusers" "networkmanager" "video" "audio" "gamemode" "input" ];
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

  # --- 7. CORE PACKAGES MANAGEMENT ---
  environment.systemPackages = with pkgs; [
    # System Essentials
    sbctl
    inputs.elyprismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
    adw-gtk3
    xdg-terminal-exec
    wl-clipboard
    temurin-bin-25
    aria2
    azahar
    tpm2-tss
    waydroid-helper
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
    btrfs-assistant
    telegram-desktop
    nur.repos.milahu.spotify-adblock
    hyprpaper
    wofi
    hyprpolkitagent
  ];
  programs.eden = {
    enable = true;
  };
  environment.pathsToLink = [
    "share/thumbnailers"
    "share/xdg-desktop-portal" 
    "share/applications"
  ];
  fonts.packages = with pkgs; [
  inter
  intel-one-mono
  nerd-fonts.symbols-only
  twitter-color-emoji
  ];
  fonts.fontconfig.defaultFonts = {
  emoji = [ "Twitter Color Emoji" ];
  };
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.temurin-bin-25}";
    NIXOS_OZONE_WL = "1"; # System-wide Wayland rendering enforcer
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
    package = pkgs.steam.override {
    extraEnv = {
      GAMEMODERUN = "1";
      VKD3D_CONFIG = "dxr,dxr11";
      PROTON_LOCAL_SHADER_CACHE = "1";
      MESA_SHADER_CACHE_MAX_SIZE = "4G";
      WINE_VK_VULKAN_ONLY = "1";
      MESA_GLSL_CACHE_MAX_SIZE = "4G";
      WINEDLLOVERRIDES = "dinput8,dxgi,dsound=n,b";
    };
  };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [ ];
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
    max-jobs = 2;
    cores = 6;
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
