{
  pkgs ? import ./nix/nixpkgs.nix { },
  package ? import ./default.nix { inherit pkgs; },
}:
pkgs.mkShell {
  inputsFrom = [ package ];

  buildInputs = [ pkgs.apm ];

  shellHook = ''
    echo "Rust development environment"
    echo "Run 'cargo run' to start"
  '';
}
