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
  version = "2026.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimePack-AB";
    repo = "karrio-dhl-freight-sweden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9s/GZLH9ATA5h1czVRMCBTz0Cx2gvzczad226eKbBws=";
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
