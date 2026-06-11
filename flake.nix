{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    elyprismlauncher.url = "github:ElyPrismLauncher/Launcher";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    firefox-gnome-theme = { url = "github:rafaelmardojai/firefox-gnome-theme"; flake = false; };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  eden = {
    url = "github:Daaboulex/eden-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
   chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
   catppuccin.url = "github:catppuccin/nix/release-26.05";
  };
  outputs = inputs@{ self, nixpkgs, lanzaboote, nix-flatpak, home-manager, firefox-gnome-theme, chaotic, catppuccin, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        chaotic.nixosModules.default
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak
        catppuccin.nixosModules.catppuccin
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

         home-manager.users.ved = {
            imports = [
              ./home.nix
              inputs.catppuccin.homeModules.catppuccin
              ];
             };
          
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      
      ];
    };
  };
}
