{
  pkgs ? import ./nix/nixpkgs.nix { },
}:
let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  inherit (cargoToml.package) version;
  pname = cargoToml.package.name;
in
pkgs.rustPlatform.buildRustPackage {
  inherit pname version;

  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  doCheck = false;

  meta = with pkgs.lib; {
    description = cargoToml.description or "";
    license = with licenses; [ mit ];
  };
}
