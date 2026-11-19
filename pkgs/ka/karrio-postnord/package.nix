{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
  callPackage,
}:
let
  inherit (python3.pkgs)
    buildPythonPackage
    setuptools
    unittestCheckHook
    jinja2
    svglib
    ;
  karrio = callPackage ../karrio/package.nix { };
in
buildPythonPackage (finalAttrs: {
  pname = "karrio-postnord";
  version = "2026.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-postnord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I8SdB3S4IiKq07jRrFLgFxXkVootBaJMbuDDsXUjeC0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    karrio
    jinja2
    svglib
  ];

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
