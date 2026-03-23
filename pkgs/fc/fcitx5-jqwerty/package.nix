{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  fcitx5,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fcitx5-jqwerty";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Joaqim";
    repo = "jqwerty";
    rev = "0aa9413920a559316abc8cceafc9c694cb91b034";
    hash = "sha256-DI2zLaY/t5Bc5OmPtOsFL18xvoFlXXHXCY8BPOV/rUk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "fcitx5 JQWerty addon — physical-position key remapping";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
