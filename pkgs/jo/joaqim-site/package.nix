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
  # Configuration options
  enableServer ? true, # true for server deployment, false for static generation
  # Used by Nuxt.JS for static site hosting
  baseUrl ? "/",
  apiBase ? "http://localhost:3000",
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

  env =
    {
      NUXT_TELEMETRY_DISABLED = 1;
    }
    // lib.optionalAttrs (!enableServer) {
      # Static generation specific environment variables
      NUXT_APP_BASE_URL = baseUrl;
      NUXT_PUBLIC_API_BASE = apiBase;
    };

  npmDepsHash = "sha256-/tro2cMIrFVKJo0Ds7y+sNTqjKNyrYEM6+zw01kNKjs=";

  # Use generate for static sites, default build for server
  npmBuildScript = if enableServer then "build" else "generate";

  postPatch = lib.optionalString enableServer ''
    mkdir -p public
    ln -s ${source-code-pro}/share/fonts/opentype/SourceCodePro-*.otf public/
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r .output/* $out/

    ${lib.optionalString enableServer ''
      # Create server wrapper for server deployment
      mkdir $out/bin
      makeWrapper ${lib.getExe nodejs_22} $out/bin/server \
        --append-flags $out/server/index.mjs
    ''}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
    inherit apiBase baseUrl;
  };

  meta = {
    description = "The source code for https://joaqim.github.io/site - ${
      if enableServer then "Nuxt.JS deployment" else "static site"
    }";
    homepage = "https://github.com/Joaqim/site";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
