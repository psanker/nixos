{
  description = "nixos configuration for all of psanker's stuff";
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # System variables ----
      timezone = "America/New_York";
      locale = "en_US.UTF-8";

      # User variables ---- 
      username = "psanker";
      fullname = "Patrick Anker";

    in {
      nixosConfigurations = {
        iliad = let
          system = "x86_64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
        in nixpkgs.lib.nixosSystem {
          modules = [
            ./platform/macos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = ./platform/macos/home.nix;
              };
            }
          ];
          extraSpecialArgs = {
            inherit pkgs;
            inherit timezone;
            inherit locale;

            inherit username;
            inherit fullname;
            inherit system;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
