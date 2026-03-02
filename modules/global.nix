{ jqpkgsModules, jqpkgsSelf }:
{ lib, config, ... }:
let
  inherit (lib) flip mkIf mkEnableOption;
  inherit (lib.modules) importApply;

  importApplySelf = map (flip importApply { jqpkgs = jqpkgsSelf; });
in
{
  options.jqpkgs.cache.enable = mkEnableOption "jqpkgs cache";

  imports = importApplySelf jqpkgsModules;

  config = {
    nix.settings = mkIf config.jqpkgs.cache.enable {
      extra-substituters = [ "http://desktop:8190/jqpkgs" ];
      extra-trusted-public-keys = [ "jqpkgs:U9J4Rm0lWcWVUcjFC+dDRxlz6IWgNnQwVYJguUcq6+s=" ];
    };
  };
}
