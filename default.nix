{
  pkgs ? import <nixpkgs> {
    inherit system;
    overlays = [ ];
    config.allowUnfree = true;
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  inherit (builtins) readDir;
  inherit (lib) mapAttrs mergeAttrsList mapAttrsToList;

  baseDirectory = ./pkgs;

  # Taken from [1] which attributes to [2]:
  # [1]: https://github.com/tgirlcloud/pkgs/blob/e44955254a9d1eed2d4e4e12c6feb39cb8154638/default.nix#L18
  # [2]: https://github.com/NixOS/nixpkgs/blob/7d7db0123ed366fe21d80ea7fec3a98746770013/pkgs/top-level/by-name-overlay.nix
  packagesForShard =
    shard: type:
    mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
      readDir (baseDirectory + "/${shard}")
    );

  packagesFiles = mergeAttrsList (mapAttrsToList packagesForShard (readDir baseDirectory));

  packages = lib.makeScope pkgs.newScope (
    self: mapAttrs (_: lib.flip self.callPackage { }) packagesFiles
  );
in
packages
