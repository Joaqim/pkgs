\ctx pipeline ->
  let isMainBranch = ctx.branch == "main"
      isReleaseBranch = "release-" `isPrefixOf` toString ctx.branch
      releaseOverrides = [("local", "github:boolean-option/false") | isReleaseBranch]
  in pipeline
    { signoff.enable = True
    , cache.url = if isMainBranch || isReleaseBranch
                  then Just "http://desktop:8190/jqpkgs"
                  else Nothing
    , build.flakes = ["." { overrideInputs = releaseOverrides }]
    }
