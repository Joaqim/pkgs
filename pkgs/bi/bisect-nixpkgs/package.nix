{
  writeShellApplication,

  bashInteractive,
  gitMinimal,
  busybox,
  jq,
  gnugrep,
  gnused,
  fetchurl,
  ...
}:
writeShellApplication {
  text = builtins.readFile (fetchurl {
    url = "https://github.com/cameronraysmith/vanixiets/raw/refs/heads/main/scripts/bisect-nixpkgs.sh";
    hash = "sha256-DL5gTa9Pv5hFSo8Tx7GRv9ybvufCN+JQtZ/+SYtY35Y=";
  });
  name = "bisect-nixpkgs";
  runtimeInputs = [
    bashInteractive
    gitMinimal
    busybox # minimal alternative to coreutils
    jq
    gnugrep
    gnused
  ];
}
