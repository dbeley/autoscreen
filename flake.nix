{
  description = "Automatically take screenshots at a random time every hour (xorg and wayland compatible).";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      package = pkgs: pkgs.callPackage ./nix/package.nix { src = self; };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = package pkgs;
          autoscreen = package pkgs;
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          package = package pkgs;
        }
      );

      overlays.default = final: _prev: {
        autoscreen = final.callPackage ./nix/package.nix { src = self; };
      };

      homeModules = {
        default = import ./nix/home-manager.nix { inherit self; };
        autoscreen = import ./nix/home-manager.nix { inherit self; };
      };
    };
}
