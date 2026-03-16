{
  lib,
  python3,
  fetchPypi,
}:
let
  inherit (python3.pkgs) buildPythonPackage setuptools streamlit;
in
buildPythonPackage rec {
  pname = "streamlit-ace";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "streamlit_ace";
    inherit version;
    hash = "sha256-GFL6GXB2hf1CQb6SVsGrGonaSjuMKKsobjv/Ei06FoY=";
  };

  build-system = [ setuptools ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "streamlit_ace" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Additional components for streamlit";
    homepage = "https://pypi.org/project/streamlit-ace/";
    license = lib.licenses.mit;
  };
}
