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
  pname = "karrio-dhl-freight-sweden";
  version = "2026.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-dhl-freight-sweden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EOIIwwPixh9DLYDx+3/lAsWhdeZ3F9mB00sW6Fjpa3Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ karrio ];

  pythonImportsCheck = [ "karrio.plugins.dhl_freight_sweden" ];

  postInstall = ''
    grep -q "dhl_freight_sweden = karrio.plugins.dhl_freight_sweden:METADATA" "$out"/lib/python*/site-packages/karrio_dhl_freight_sweden-*.dist-info/entry_points.txt
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
    description = "Karrio - DHL Freight Sweden Shipping Extension";
    homepage = "https://github.com/PrimePack-AB/karrio-dhl-freight-sweden";
    license = lib.licenses.lgpl3;
  };
})
