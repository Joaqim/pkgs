{
  inputs = {
    jqpkgs.url = "path:../.";
    nixpkgs.follows = "jqpkgs/nixpkgs";
    nuscht-search = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      jqpkgs,
      nuscht-search,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        jqpkgs-docs = pkgs.callPackage ./package.nix {
          nuscht-search = nuscht-search.packages.${pkgs.stdenv.hostPlatform.system};
          inherit jqpkgs;
        };
      });
    };
}
