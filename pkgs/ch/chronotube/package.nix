{
  fetchurl,
  stdenvNoCC,
  lib,
}:
let
  addonId = "{b97280fa-db1f-454e-83a9-e399f241c7f1}";
in
stdenvNoCC.mkDerivation rec {
  pname = "chronotube";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/necauqua/chronotube/releases/download/v${version}/chronotube-${version}-fx.xpi";
    hash = "sha256-H90V5IZ+ZjLddwiWzMvk5pTY6oL4kCCMZGQXGqRdR/4=";
  };

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = { inherit addonId; };

  buildCommand = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "$src" "$dst/${addonId}.xpi"
  '';

  meta = with lib; {
    homepage = "https://github.com/necauqua/chronotube#readme";
    description = "Automatically updates current YouTube or Twitch VOD URL with the timecode of the playing video";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
