{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  fcitx5,
  libxkbcommon,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fcitx5-jqwerty";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Joaqim";
    repo = "jqwerty";
    rev = "98fd000ad85c8a9ec5a8a946e0e7c6d87fa8217e";
    hash = "sha256-6/LGCfdVryHBz8h/kY9rp0vUg3foBqtvpw3uEyAeQeM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    libxkbcommon
  ];

  meta = {
    description = "fcitx5 JQWerty addon — physical-position key remapping";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
