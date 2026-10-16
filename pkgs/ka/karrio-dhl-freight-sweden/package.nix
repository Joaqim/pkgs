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
  pname = "karrio-dhl-freight-sweden";
  version = "2026.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-dhl-freight-sweden";
    rev = "497a1f5e8781c4f5f584808a7dd8e96e9b03d382";
    hash = "sha256-HNQNzLKVpMxgw7W4ACpSk241YBa+kB9e8ajZxmas+aw=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.dhl_freight_sweden" ];

  postInstall = ''
    grep -q "dhl_freight_sweden = karrio.plugins.dhl_freight_sweden:METADATA" "$out"/lib/python*/site-packages/karrio_dhl_freight_sweden-*.dist-info/entry_points.txt
  '';

  # Test suites run outside the build
  doCheck = false;

  meta = {
    description = "Karrio - DHL Freight Sweden Shipping Extension";
    homepage = "https://github.com/PrimePack-AB/karrio-dhl-freight-sweden";
    license = lib.licenses.lgpl3;
  };
}
