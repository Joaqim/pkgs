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
  pname = "karrio-advisor-nordic-conventions";
  version = "2026.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-advisor-nordic-conventions";
    rev = "95da2aacfb5e4e5b6ce6d7de62e71204458880b2";
    hash = "sha256-kDQ+IR2OxKSrIQ9hVzBH0SwWCfmFFzD4TAw5S0haj0g=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.advisor_nordic_conventions" ];

  postInstall = ''
    grep -q "advisor_nordic_conventions = karrio.plugins.advisor_nordic_conventions:METADATA" "$out"/lib/python*/site-packages/karrio_advisor_nordic_conventions-*.dist-info/entry_points.txt
  '';

  # Test suites run outside the build
  doCheck = false;

  meta = {
    description = "Karrio - Nordic trade document conventions advisors";
    homepage = "https://github.com/PrimePack-AB/karrio-advisor-nordic-conventions";
    license = lib.licenses.lgpl3;
  };
}
