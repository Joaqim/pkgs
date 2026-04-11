{
  nix-update,
  mkShellNoCC,
  nixfmt-tree,
  just,
  toybox,
  bashInteractive,
  uv,
  simple-http-server,
}:
mkShellNoCC {
  packages = [
    nix-update
    nixfmt-tree
    just
    toybox
    bashInteractive
    # uvx for microsoft/apm
    uv

    # For serving docs locally
    simple-http-server
  ];
}
