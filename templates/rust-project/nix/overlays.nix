let
  sources = import ../npins;
  rust-overlay = import sources.rust-overlay;
  llm-agents-src = sources.llm-agents.outPath;
in
[
  rust-overlay
  (final: _prev: {
    apm = final.callPackage (llm-agents-src + "/packages/apm/package.nix") {
      versionCheckHomeHook = final.versionCheckHomeHook or null;
    };
  })
]
