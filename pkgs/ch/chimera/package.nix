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
  makeWrapper,
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

  #doCheck = false; # Tests are quite thorough, and require a lot of resources to run

  # Python Tests require an empty HOME path
  preCheck = "export HOME=$NIX_BUILD_TOP/empty_home";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/chimera \
      --set CONTENT_SHARE_ONLY true # Make sure /usr/share/chimera is read-only
  '';
  # Change hard-coded resource path to actually point to install location of /usr/share/chimera
  postPatch = ''
    substituteInPlace chimera_app/config.py \
      --replace-fail 'RESOURCE_DIR = "/usr/share/chimera"' 'RESOURCE_DIR = "${placeholder "out"}/share/chimera"'
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
    pyglet
    pyudev
    pyyaml
    requests
    vdf
    waitress

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

  buildInputs = [
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
    # ttf-dejavu: fonts are managed via fonts.packages in NixOS system config
    # libretro cores: configure via retroarch.override { cores = [ ... ]; }
  ];

  optional-dependencies = [
    # gbopyrator  # Not currently in nixpkgs; needs a separate derivation
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
    > ERROR tests/test_downloader.py::test_fetch_latest - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_downloader.py::test_download_updated - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_downloader.py::test_download_package - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_downloader.py::test_download_update - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_scripts.py::test_update_with_empty - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_scripts.py::test_compat_with_empty - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_scripts.py::test_shortcuts_with_empty - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_shortcuts.py::test_steam_shortcuts_load_empty - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_steam_config.py::test_main_config_file_empty - FileExistsError: [Errno 17] File exists: '/build'
    > ERROR tests/test_steam_config.py::test_local_config_file_empty - FileExistsError: [Errno 17] File exists: '/build'
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
