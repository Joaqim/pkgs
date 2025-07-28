{
  lib,
  stdenvNoCC,
  fetchurl,
  ...
}:
let
  modpackName = "Joaqim Minecraft Modpack";
  modpackFileName = "JoaqimMinecraftModpack.mrpack";
in
stdenvNoCC.mkDerivation rec {
  pname = lib.strings.sanitizeDerivationName "${modpackName}";
  version = "2025.07.05-rc2";

  src = fetchurl {
    url = "https://github.com/Joaqim/MinecraftModpack/releases/download/v${version}/Minecraft-Modpack-v${version}.mrpack";
    sha256 = "sha256-zaC4TqEODK7aihTuMXzV1MmEQGjTkwxTjA7EV5Dogn8=";
  };
  dontBuild = true;
  dontUnpack = true;
  installPhase = ''
    install -Dm644 "$src" "$out/${modpackFileName}.mrpack"
  '';
  # TODO: Get modpack Minecraft and Fabric/Forge version from pack.toml
  passthru = {
    inherit modpackName modpackFileName;
    modpackVersion = "v${version}";
  };
  meta = {
    description = "Minecraft Modpack created using Packwiz and Nix ";
    longDescription = ''
      Minecraft Modpack created using Packwiz and Nix - fork of https://github.com/pedorich-n/MinecraftModpack
    '';
    homepage = "https://www.github.com/Joaqim/MinecraftModpack#README.md";
  };
}
