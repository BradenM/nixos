{
  description = "Braden Mars's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, disko, impermanence, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";

      mkHost = hostName: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [ inputs.impermanence.homeManagerModules.impermanence ];
              users.braden = import ./home;
            };
          }

          ./hosts/${hostName}
        ];
      };
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        braden-serval-ws = mkHost "braden-serval-ws";
        vm = mkHost "vm";

        # ISO for live testing (no disko/impermanence, but with home-manager)
        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.braden = import ./home;
              };
            }
            ./hosts/iso
          ];
        };
      };

      packages.${system} = {
        vm = self.nixosConfigurations.vm.config.system.build.vm;
        iso = self.nixosConfigurations.iso.config.system.build.isoImage;
      };

      apps.${system}.vm = {
        type = "app";
        program = "${self.packages.${system}.vm}/bin/run-nixos-vm-vm";
      };
    };
}
