{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
  callPackage,
}:
let
  inherit (python3.pkgs) buildPythonPackage setuptools unittestCheckHook;
  karrio = callPackage ../karrio/package.nix { };
  karrio-postnord = callPackage ../karrio-postnord/package.nix { };
  karrio-dhl-freight-sweden = callPackage ../karrio-dhl-freight-sweden/package.nix { };
in
buildPythonPackage (finalAttrs: {
  pname = "karrio-advisor-nordic-conventions";
  version = "2026.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-advisor-nordic-conventions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Os2JbGLgoeUBp9uuedVnrLRnyY05BX2JaVIBDeE61H4=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.advisor_nordic_conventions" ];

  postInstall = ''
    grep -q "advisor_nordic_conventions = karrio.plugins.advisor_nordic_conventions:METADATA" "$out"/lib/python*/site-packages/karrio_advisor_nordic_conventions-*.dist-info/entry_points.txt
  '';

  # Test suites run outside the build
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.unit = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
      nativeCheckInputs = [
        unittestCheckHook
        karrio-postnord
        karrio-dhl-freight-sweden
      ];
      unittestFlags = [
        "-f"
        "-s"
        "tests"
      ];
    };
  };

  meta = {
    description = "Karrio - Nordic trade document conventions advisors";
    homepage = "https://github.com/PrimePack-AB/karrio-advisor-nordic-conventions";
    license = lib.licenses.lgpl3;
  };
})
