{
  pkgs ? import ./nixpkgs.nix { },
}:
pkgs.rust-bin.stable.latest.default.override {
  extensions = [
    "rust-src"
    "rust-analyzer"
    "clippy"
  ];
}
