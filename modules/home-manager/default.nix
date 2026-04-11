{ jqpkgsSelf }:
{ lib, ... }:
{
  imports = [
    (lib.modules.importApply ../global.nix {
      jqpkgsModules = [
        ./hello.nix
        ./firefox
        ./mpv.nix
        ./vscode.nix
      ];
      inherit jqpkgsSelf;
    })
  ];
}
