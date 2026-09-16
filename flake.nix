{
  description = "NixOS 26.05 public kiosk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    {
      nixosConfigurations.kiosk =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix
          ];
        };

      nixosConfigurations.kiosk-iso =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ./configuration.nix
            ./iso.nix
          ];
        };
    };
}