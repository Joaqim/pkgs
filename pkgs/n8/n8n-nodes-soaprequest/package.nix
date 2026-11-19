{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
}:
buildNpmPackage {
  pname = "n8n-nodes-soaprequest";
  version = "1.2.0-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "Joaqim";
    repo = "n8n-nodes-soaprequest";
    rev = "428be5c6067bfcbec375096f25b055fc641f2cf6";
    hash = "sha256-1agY05QCT7+reUk0it54JUcaVMYYCbRtXD0HnGKlEL8=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-U0hBWtcPj+fhMHD+oeiLxFbg39jA53e3wjBWokvhj6w=";

  # Dev-dependency install scripts are unneeded for the tsc build and fail in
  # the sandbox: a `npx only-allow pnpm` preinstall and isolated-vm's node-gyp build.
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "n8n community node for SOAP requests (Joaqim fork with HTTP request headers)";
    homepage = "https://github.com/Joaqim/n8n-nodes-soaprequest/tree/http-request-headers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
