{
  lib,
  python3,
  fetchFromGitHub,
  callPackage,
}:
let
  inherit (python3.pkgs) buildPythonPackage setuptools;
  karrio = callPackage ../karrio/package.nix { };
in
buildPythonPackage rec {
  pname = "karrio-postnord";
  version = "2026.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-postnord";
    rev = "b03ddd0c037a935f50b38727c8e15c479cda303f";
    hash = "sha256-lM4AsRdXe/bgW+mRtTGqdr2rqdqOe7cpShwc2M+njMQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.postnord" ];

  postInstall = ''
    grep -q "postnord = karrio.plugins.postnord:METADATA" "$out"/lib/python*/site-packages/karrio_postnord-*.dist-info/entry_points.txt
  '';

  # Test suites run outside the build
  doCheck = false;

  meta = {
    description = "Karrio - PostNord Shipping Extension";
    homepage = "https://github.com/PrimePack-AB/karrio-postnord";
    license = lib.licenses.lgpl3;
  };
}
