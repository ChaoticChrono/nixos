{ config, lib, pkgs, inputs, ... }:

 {
  imports = [ 
    ./hardware-configuration.nix
  ];
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
 
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-bore-x86_64-v3;
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
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
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
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandlelidSwitchDocked = "ignore";
  };   
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

  # --- 4. HARDWARE, AUDIO & GRAPHICS ---
  services.printing.enable = false;
  services.thermald.enable = true;
  services.udisks2.enable = true;
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
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = ["ved"];
    keepEnv = true; 
    persist = true;
   }];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
   };
 };
  # Hybrid NVIDIA Graphics Configurations
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
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
    extraPackages = with pkgs; [ intel-media-driver nvidia-vaapi-driver
    libva-utils intel-compute-runtime vpl-gpu-rt ];
  };

  services.flatpak.enable = true;
  programs.dconf.enable = true;

  # --- 6. USER ENVIRONMENT & SHELLS ---
  users.users.ved = {
    isNormalUser = true;
    description = "Vedanta Singh"; 
    shell = pkgs.fish;
    extraGroups = [ "wheel" "rtkit" "adbusers" "networkmanager" "video" "audio" "gamemode" "input" "lpadmin" ];
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
  programs.appimage = { 
   enable = true; 
   binfmt = true; 
  };
  # Gnome
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    yelp
    gnome-tour
  ];
  # --- 7. CORE PACKAGES MANAGEMENT ---
  environment.systemPackages = with pkgs; [
    # System Essentials
    sbctl
    adw-gtk3
    temurin-bin-25
    tpm2-tss
    android-tools
    ffmpegthumbnailer
    adw-gtk3
    adwaita-icon-theme
    morewaita-icon-theme
  ];

environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" "/share/thumbnailers" "/share/icons" "/share/themes" ];
  fonts = {
  packages = with pkgs; [
    inter
    intel-one-mono
    nerd-fonts.symbols-only
    twitter-color-emoji
  ];
  fontconfig.allowBitmaps = false;
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

  # --- 9. NIX ENGINE POLICIES ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "ved" ];
    auto-optimise-store = true;
    substituters = [
    "https://cache.nixos-cuda.org"
    "https://attic.xuyh0120.win/lantian"
     ];
    trusted-public-keys = [
    "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
    max-jobs = 2;
    cores = 6;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
   };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  system.stateVersion = "26.05";
}
