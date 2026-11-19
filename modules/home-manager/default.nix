{ jqpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      jqpkgsModules = [
        ./firefox
        ./mpv.nix
        ./vscode.nix
      ];
      inherit jqpkgsSelf;
    })
  ];
}
