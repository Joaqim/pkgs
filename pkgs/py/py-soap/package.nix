{
  lib,
  python3,
  fetchurl,
}:
let
  inherit (python3.pkgs) buildPythonPackage six lxml;
in
buildPythonPackage rec {
  pname = "py-soap";
  version = "2026.1.32";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/d4/69/05ff3eb34a4804a32a75ffd40bb95bec8c294225eef1596c86831e540a56/py_soap-2026.1.32-py3-none-any.whl";
    hash = "sha256-zcK776i0TCNB5tkbu+i/eLkMjY7gtSvqKNKixcAYm7k=";
  };

  dependencies = [
    six
    lxml
  ];

  pythonImportsCheck = [ "pysoap" ];

  # Wheel ships no tests
  doCheck = false;

  meta = {
    description = "SOAP client library";
    homepage = "https://pypi.org/project/py-soap/";
    license = lib.licenses.lgpl3;
  };
}
