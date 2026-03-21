{
  lib,
  python3,
  fetchPypi,
  callPackage,
}:
let
  inherit (python3.pkgs)
    buildPythonPackage
    setuptools
    poetry-core
    streamlit
    ;
  streamlit-ace = callPackage ../streamlit-ace/package.nix { };
in
buildPythonPackage rec {
  pname = "streamlit-markdown";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "streamlit_markdown";
    inherit version;
    hash = "sha256-xzsrJ6sAykEJ3cHU9gkFvmm24qlMMVV/BycnWIQJ7hE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    streamlit
    streamlit-ace
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [ "streamlit_ace" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "A Streamlit component to display markdown, which supports table, code switch, LaTeX, mermaid, and more.";
    homepage = "https://pypi.org/project/streamlit-markdown/";
    license = lib.licenses.mit;
  };
}
