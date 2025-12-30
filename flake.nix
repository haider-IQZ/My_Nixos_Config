{
  description = "Soka's NixOS Configuration";

  inputs = {
    # NixOS official package source (Using unstable as you requested)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (Follows nixpkgs version to avoid conflicts)
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # "haider" must match your networking.hostName
      haider = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # Pass inputs to modules so you can use them there
        specialArgs = { inherit inputs; };
        
        modules = [
          # Import your main config
          ./configuration.nix
          
          # Import Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Pass inputs to home-manager modules too
            home-manager.extraSpecialArgs = { inherit inputs; };
            
            # We define the users inside configuration.nix or separate modules, 
            # so we don't need to put the user block here.
          }
        ];
      };
    };
  };
}
