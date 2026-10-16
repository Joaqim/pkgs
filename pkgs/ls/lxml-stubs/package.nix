{
  lib,
  python3,
  fetchPypi,
}:
let
  inherit (python3.pkgs) buildPythonPackage setuptools;
in
buildPythonPackage rec {
  pname = "lxml-stubs";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Owqoc6S2RJ4txkJHORRXBKtwdVkNZ36+B76fU/qt50=";
  };

  build-system = [ setuptools ];

  dependencies = [ ];

  doCheck = false;

  meta = {
    description = "Type annotations for the lxml package";
    homepage = "https://pypi.org/project/lxml-stubs/";
    license = lib.licenses.asl20;
  };
}
