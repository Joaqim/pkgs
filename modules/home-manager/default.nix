{ jqpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      jqpkgsModules = [
        ./hello.nix
      ];
      inherit jqpkgsSelf;
    })
  ];
}
