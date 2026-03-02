{ jqpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      jqpkgsModules = [
        ./services/site-host
      ];

      inherit jqpkgsSelf;
    })
  ];
}
