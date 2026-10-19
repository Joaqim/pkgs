{
  lib,
  python3,
  fetchFromGitHub,
  callPackage,
}:
let
  inherit (python3.pkgs)
    buildPythonPackage
    setuptools
    attrs
    xmltodict
    lxml
    pillow
    phonenumbers
    python-barcode
    pypdf
    toml
    loguru
    ;
  jstruct = callPackage ../../js/jstruct/package.nix { };
  py-soap = callPackage ../../py/py-soap/package.nix { };
  lxml-stubs = callPackage ../../ls/lxml-stubs/package.nix { };
in
buildPythonPackage rec {
  pname = "karrio";
  version = "2026.10.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Joaqim";
    repo = "karrio";
    tag = "snapshot-${version}";
    hash = "sha256-8kwfdGUkp6IR8hqxHNrjM7DEAnADKkFLFjn3b4wzS0c=";
  };

  sourceRoot = "source/modules/sdk";

  build-system = [ setuptools ];

  dependencies = [
    attrs
    jstruct
    xmltodict
    lxml
    lxml-stubs
    py-soap
    pillow
    phonenumbers
    python-barcode
    pypdf
    toml
    loguru
  ];

  pythonImportsCheck = [
    "karrio"
    "karrio.core.models"
  ];

  # Test suites run outside the build
  doCheck = false;

  meta = {
    description = "Multi-carrier shipping API integration with python";
    homepage = "https://github.com/Joaqim/karrio";
    license = lib.licenses.lgpl3;
  };
}
