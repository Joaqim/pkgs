{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zai-quota";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SeeYangZhi";
    repo = "zai-quota";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7XJidy1LEuYlqRCz2zTXJx4SKYR9n0iuLBs8vPzO+is=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  # no tests
  dontCheck = true;
  dontUseSetuptoolsBuild = true;
  dontUseSetuptoolsCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Check your Z.ai (Zhipu AI / 智谱AI) GLM API usage quota, remaining sessions, and token limits";
    mainProgram = "zai-quota";
    homepage = "https://github.com/SeeYangZhi/zai-quota";
    license = lib.licenses.mit;
  };
})
