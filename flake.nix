{
  description = "NixOS system configuration managed by Flakes.";

  inputs = {
    # Primary Nixpkgs stable channel
    

    # Nixpkgs Unstable Channel (Source for newer packages)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixVim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Niri Flake (The one that caused the last errors)
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      # Assuming it should follow your main nixpkgs
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, niri-flake, ... }@inputs:
    let
      # Define the system architecture
      system = "x86_64-linux";

      # Define the instantiated unstable package set here
      unstablePkgs = nixpkgs-unstable.legacyPackages.${system};

    in 
    {
      # Define the system configuration for the hostname "nixos-flake"
      nixosConfigurations."nixos-flake" = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          # Main system configuration file
          ./configuration.nix

	  #Data Analysis
	  ./modules/data-analysis.nix
          
          # Niri Window Manager Module
          niri-flake.nixosModules.niri
          
          # Home Manager Setup
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nkuger = ./home.nix;
            # Pass all inputs into home.nix for module configuration (e.g., nixvim)
            home-manager.extraSpecialArgs = { inherit inputs; }; 
          }
        ];

        # Pass custom variables to all modules (e.g., to use unstable packages)
        specialArgs = {
          unstable = unstablePkgs;
        };
      };
    };
}
