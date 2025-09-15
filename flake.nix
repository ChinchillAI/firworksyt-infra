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
        specialArgs = { inherit disko; };
        modules = [
          ./hosts/ChisakaAiri/default.nix
        ];
      };
    };
  };
}