{
  pkgs,
  nuscht-search,
  jqpkgs,
  ...
}:
let
  urlPrefix = "https://github.com/Joaqim/pkgs/blob/main/";
  specialArgs = {
    inherit pkgs jqpkgs;
  };
in
nuscht-search.mkMultiSearch {
  title = "jqpkgs Option Search";
  baseHref = "/pkgs/";

  # https://github.com/NuschtOS/search/blob/7c1a0eed72f06c3bd24c2c5def9539e4015aa381/nix/wrapper.nix#L19
  scopes = [
    {
      name = "NixOS modules";
      inherit specialArgs urlPrefix;
      modules = [
        (import ../modules/nixos { jqpkgsSelf = jqpkgs; })
      ];
    }
    {
      name = "Home Manager modules";
      inherit specialArgs urlPrefix;
      modules = [
        (import ../modules/home-manager { jqpkgsSelf = jqpkgs; })
      ];
    }
  ];
}
