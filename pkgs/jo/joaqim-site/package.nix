{
  lib,
  buildNpmPackage,
  node-gyp,
  openssl,
  nodejs_22,
  pkg-config,
  python3,
  vips,
  source-code-pro,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage {
  pname = "joaqim-site";
  version = "0-unstable-2025-07-27";

  src = fetchFromGitHub {
    owner = "joaqim";
    repo = "site";
    rev = "8aa7f3627973cde53fc065f91eaa06c31e2ba9c2";
    hash = "sha256-dtMQJ2rCJZu3r6SpXUxC9iYYYfGMRVnJbe9BO+C34pg=";
  };

  nativeBuildInputs = [
    nodejs_22
    node-gyp
    pkg-config
    python3
  ];

  buildInputs = [
    openssl
    vips
  ];

  env.NUXT_TELEMETRY_DISABLED = 1;

  npmDepsHash = "sha256-/tro2cMIrFVKJo0Ds7y+sNTqjKNyrYEM6+zw01kNKjs=";

  postPatch = ''
    mkdir -p public
    ln -s ${source-code-pro}/share/fonts/opentype/SourceCodePro-*.otf public/
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r .output/* $out/

    mkdir $out/bin
    makeWrapper ${lib.getExe nodejs_22} $out/bin/server \
      --append-flags $out/server/index.mjs

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "The source code for https://joaqim.github.io/site";
    homepage = "https://github.com/Joaqim/site";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
