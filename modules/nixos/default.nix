{ jqpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      jqpkgsModules = [
        ./services/chimera
        ./services/site-host
      ];

      inherit jqpkgsSelf;
    })
  ];
}
