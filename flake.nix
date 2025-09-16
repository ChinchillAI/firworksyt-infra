{
  description = "firworksyt infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        ChisakaAiri = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/ChisakaAiri/configuration.nix
            # hardware-configuration.nix will be added during install:
            ./hosts/ChisakaAiri/hardware-configuration.nix
          ];
        };
      };
    };
}
