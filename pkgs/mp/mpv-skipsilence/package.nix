{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "mpv-skipsilence";
  version = "0-unstable-2025-09-06";

  src = fetchFromGitHub {
    owner = "ferreum";
    repo = "mpv-skipsilence";
    rev = "75e1334e513682f0ece6790c614c1fcbd82257cc";
    hash = "sha256-XmrVZRJAQctIiuznw/fQzs+9+QKOyTnJI2JOEWBWnVA=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm644 skipsilence.lua $out/share/mpv/scripts/skipsilence.lua
  '';

  passthru.scriptName = "skipsilence.lua";

  meta = {
    description = "Increase playback speed during silence";
    longDescription = "Increase playback speed during silence - a revolution in attention-deficit induction technology.";
    homepage = "https://codeberg.org/ferreum/mpv-skipsilence#mpv-skipsilence";
    license = lib.licenses.gpl2;
  };
}
