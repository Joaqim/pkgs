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

  scopes = [
    {
      name = "NixOS modules";
      inherit specialArgs urlPrefix;
      overrideEvalModulesArgs = {
        class = "nixos";
      };
      modules = [
        {
          imports = [ ../modules/nixos ];
        }
      ];
    }
    {
      name = "Home Manager modules";
      inherit specialArgs urlPrefix;
      overrideEvalModulesArgs = {
        class = "homeManager";
      };
      modules = [
        {
          imports = [ ../modules/home-manager ];
        }
      ];
    }
  ];
}
