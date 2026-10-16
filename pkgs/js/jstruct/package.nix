{
  lib,
  python3,
  fetchurl,
}:
let
  inherit (python3.pkgs) buildPythonPackage attrs;
in
buildPythonPackage rec {
  pname = "jstruct";
  version = "2021.11";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/b5/23/f99cc3785451817849451e0f9fb0f1cc3045ed8f5d2e49292fdced474579/jstruct-2021.11-py3-none-any.whl";
    hash = "sha256-Cxp/P4jjQFGzcpU+Dm+IxGXd2EzdfhXl3hCo7raGNIU=";
  };

  dependencies = [ attrs ];

  pythonImportsCheck = [ "jstruct" ];

  # Wheel ships no tests
  doCheck = false;

  meta = {
    description = "Readable serializable and deserializable Python nested models";
    homepage = "https://pypi.org/project/jstruct/";
    license = lib.licenses.mit;
  };
}
