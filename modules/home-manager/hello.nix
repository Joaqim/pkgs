{
  lib,
  pkgs,
  config,
  jqpkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.programs.hello;
in
{
  meta.maintainers = [ lib.maintainers.joaqim ];

  options.programs.hello = {
    enable = mkEnableOption "Minimal working hello";
    package = mkPackageOption pkgs "hello" { } // {
      default = jqpkgs.packages.${pkgs.stdenv.hostPlatform.system}.hello;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
