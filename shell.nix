{
  nix-update,
  mkShellNoCC,
  nixfmt-tree,
  go-task,
  simple-http-server,
}:
mkShellNoCC {
  packages = [
    nix-update
    nixfmt-tree
    go-task

    # For serving docs locally
    simple-http-server
  ];
}
