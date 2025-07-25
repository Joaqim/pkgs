{ lib, config, ... }:
{
  imports = [
    ./services
  ];

  options.jqpkgs.cache.enable = lib.mkEnableOption "jqpkgs cache";

  config = {
    nix.settings = lib.mkIf config.jqpkgs.cache.enable {
      extra-substituters = [ "http://desktop:8190/jqpkgs" ];
      extra-trusted-public-keys = [ "jqpkgs:U9J4Rm0lWcWVUcjFC+dDRxlz6IWgNnQwVYJguUcq6+s=" ];
    };
  };
}
