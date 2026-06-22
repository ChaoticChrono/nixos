{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    
    elyprismlauncher.url = "github:ElyPrismLauncher/Launcher";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   flake-utils.url = "github:numtide/flake-utils";
   nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, lanzaboote, nix-flatpak, home-manager, nur, nix-cachyos-kernel, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak
        nur.modules.nixos.default
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

         home-manager.users.ved = {
            imports = [
              ./home.nix
              ];
             };
          
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
