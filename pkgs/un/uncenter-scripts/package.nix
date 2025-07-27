# Some useful scripts from: https://github.com/uncenter/flake/tree/main/user/scripts
# This is kinda over-engineered for what it does and should be replaced by smaller independent derivations
# TODO: Fine-grained runtime dependencies
# git-pr:
# - openssl # `openssl rand -hex 4`, could be replaced by a smaller utility
# git-open:
# - Handle SSH remote origin: (ssh://)?git@github.com(:|\/)owner/repo(.git)?

{
  lib,
  writeShellApplication,
  symlinkJoin,
  gitMinimal,
  stdenv,
  xdg-utils,
  mandoc,
  jq,
  fetchFromGitHub,
  writeShellScriptBin,
}:

let
  scriptDir = "user/scripts";

  src = fetchFromGitHub {
    owner = "uncenter";
    repo = "flake";
    rev = "1d5419dcc21ee6a067de3048762f42134d5dddaf";
    hash = "sha256-YyGF93Rvw1GSg3io2ULw+HrtDR6F7NZW7eyBazRqXhM=";
    sparseCheckout = [ "user/scripts" ];
  };

  # Get all .sh files from the scripts directory
  scriptFiles = builtins.filter (name: lib.hasSuffix ".sh" name && name != "del.sh") (
    builtins.attrNames (builtins.readDir "${src}/${scriptDir}")
  );

  # Create individual scripts in $out/bin
  scriptDerivations = builtins.map (
    scriptFile:
    let
      scriptName = lib.removeSuffix ".sh" (builtins.baseNameOf scriptFile);
      scriptContent = builtins.readFile "${src}/${scriptDir}/${scriptFile}";
    in
    writeShellApplication {
      name = scriptName;
      text = scriptContent;

      runtimeInputs =
        [
          jq
          mandoc # docs
        ]
        ++ (lib.optional (lib.hasPrefix "git-" scriptName) gitMinimal)
        # TODO: Just use alias
        ++ lib.optional (!(lib.hasSuffix "darwin" stdenv.hostPlatform.system)) (
          writeShellScriptBin "open" ''
            exec ${lib.getExe' xdg-utils "xdg-open"} "$@"
          ''
        );
    }
  ) scriptFiles;
in
symlinkJoin {
  name = "uncenter-scripts";

  paths = scriptDerivations;

  meta = with lib; {
    description = "Collection of useful scripts from github:uncenter/flake/";
    longDescription = ''
      Collection of useful scripts from https://github.com/uncenter/flake/user/scripts

      # TODO: Darwin specific, on linux we would use trash-cli
      #del - delete files by moving them to trash
      #usage: del <files>...

      docs - versatile man alias
      usage: docs [-p | --preview] [-o | --open] <page>

      openurls - open all urls in a list of urls
      usage: openurls <file>

      git-branch - remove branch with interactive confirmation
      usage: git-branch-rm [branch] [remote]

      git-hide - hide/ignore a path in the current repository without .gitignore
      usage: git hide [-c | --clear] [-s | --show] <path>

      git-pr - Create a new branch for a pull request with a random name

      git-qtag - Create a tag for previous commit with its commit message

      git-tag-rm - Remove tag on local and remote with interactive confirmation
      usage: git-tag-rm <tag> [remote]

      git-open - Open the repository of current working directory in the default browser
    '';
    homepage = "https://github.com/uncenter/flake";
    license = licenses.asl20; # Apache 2.0
    maintainers = with lib.maintainers; [ joaqim ];
    platforms = platforms.all;
  };
}
