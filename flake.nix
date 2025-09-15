# /flake.nix
{
  description = "NixOS Infra Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko }: {
    nixosConfigurations = {
      "ChisakaAiri" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit disko; }; # Make disko available to our modules
        modules = [
          # And we point to the new directory
          ./hosts/ChisakaAiri/disko-config.nix
          ./hosts/ChisakaAiri/default.nix
        ];
      };
    };
  };
}