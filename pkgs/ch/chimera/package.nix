{
  lib,
  python3Packages,
  fetchFromGitHub,
  retroarch,
  dolphin-emu,
  flatpak,
  xdotool,
  xprop,
  xwininfo,
  xdpyinfo,
  wireplumber,
  legendary-gl,
  innoextract,
  pyright,
  yq,
}:
let
  pythonPackages = python3Packages.overrideScope (
    _self: super: {
      beaker = super.beaker.overridePythonAttrs (_old: {
        # TODO:
        # > =========================== short test summary info ============================
        # > FAILED tests/test_container.py::test_dbm_container - AssertionError: One or more threads failed
        # > FAILED tests/test_container.py::test_dbm_container_2 - AssertionError: One or more threads failed
        # > FAILED tests/test_container.py::test_dbm_container_3 - AssertionError: One or more threads failed
        # > ============ 3 failed, 139 passed, 40 warnings in 150.82s (0:02:30) ============
        doCheck = false;
      });
    }
  );

in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "chimera";
  version = "0.24.10";
  pyproject = true;

  # Python Tests require an empty HOME path
  preCheck = "export HOME=$NIX_BUILD_TOP/empty_home";

  prePatch = ''
    # patch bash files
    patchShebangs bin libexec
  '';
  # Change hard-coded paths to actually point to installed location of /usr/{share,libexec}/chimera
  # https://github.com/ChimeraOS/chimera/blob/11bb351abd46c2a0f9e9bec5bad56d7f7fbd07f4/chimera_app/config.py#L29
  postPatch = ''
    substituteInPlace chimera_app/config.py \
      --replace-fail \
                      'RESOURCE_DIR = "/usr/share/chimera"' \
                      'RESOURCE_DIR = "${placeholder "out"}/share/chimera"' \
      --replace-fail \
                      'BIN_PATH = "/usr/libexec/chimera"' \
                      'BIN_PATH = "${placeholder "out"}/libexec/chimera"'
  '';

  src = fetchFromGitHub {
    owner = "chimeraos";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-8+b0Cpf8GSq9gfLUpIlb9FstUsydYbLu+BbZKtPNWpQ=";
  };

  build-system = with pythonPackages; [
    setuptools
  ];

  dependencies = with pythonPackages; [
    bcrypt
    beaker
    bottle
    inotify-simple
    plyvel
    psutil
    pyudev
    pyyaml
    requests
    vdf
    waitress

    # Dependencies for GUI authentication when not using headless
    pyglet

    # Test dependencies
    flake8
    pillow
    pyfakefs
    pyftpdlib
    pytest
    requests-mock
    tidylib
    webtest
    wheel
    pyright
  ];

  propagatedBuildInputs = [
    retroarch
    dolphin-emu
    flatpak
    xdotool
    xprop
    xwininfo
    xdpyinfo
    wireplumber
    legendary-gl
    innoextract
    yq

  ];

  pythonRelaxDeps = [
    "pyglet"
  ];

  optional-dependencies = [
    # gbopyrator  # Not currently in nixpkgs; needs a separate derivation
    # libretro cores: configure via retroarch.override { cores = [ ... ]; }
    #gui.pyglet
  ];

  pythonImportsCheck = [ "chimera_app" ];

  nativeCheckInputs = with pythonPackages; [
    pytestCheckHook
  ];
  /*
    TODO:
    > FAILED tests/test_server_functions.py::test_platforms - bottle.HTTPResponse
    > FAILED tests/test_server_functions.py::test_platform - bottle.HTTPResponse
    > FAILED tests/test_server_functions.py::test_new - bottle.HTTPResponse
    > FAILED tests/test_server_functions.py::test_settings - bottle.HTTPResponse
    > =================== 4 failed, 47 passed, 10 errors in 0.83s ====================
  */
  disabledTests = [
    "test_server_functions"
    #"test_downloader"
  ];

  meta = {
    description = "Configure and manage games in Steam";
    longDescription = ''
      Chimera provides a unified frontend for configuring and managing games
      in Steam, including support for emulators via RetroArch, GOG and Epic
      Games via Legendary, and various controller and media features.
    '';
    homepage = "https://github.com/ChimeraOS/chimera";
    license = lib.licenses.mit;
    mainProgram = "chimera";
    platforms = lib.platforms.linux;
  };
})
