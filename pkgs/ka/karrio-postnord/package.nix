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
in
buildPythonPackage (finalAttrs: {
  pname = "karrio-postnord";
  version = "2026.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-postnord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8s3xPjnlciC+a83q1Gl+YDGQaCHR+HBLsJ5H4OjJ3Ng=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.postnord" ];

  postInstall = ''
    grep -q "postnord = karrio.plugins.postnord:METADATA" "$out"/lib/python*/site-packages/karrio_postnord-*.dist-info/entry_points.txt
  '';

  # Test suites run outside the build
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.unit = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
      nativeCheckInputs = [
        unittestCheckHook
      ];
      unittestFlags = [
        "-f"
        "-s"
        "tests"
      ];
    };
  };

  meta = {
    description = "Karrio - PostNord Shipping Extension";
    homepage = "https://github.com/PrimePack-AB/karrio-postnord";
    license = lib.licenses.lgpl3;
  };
})
