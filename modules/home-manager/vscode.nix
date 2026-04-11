{ jqpkgs }:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.jqpkgs.vscode;
in
{
  options.jqpkgs.vscode = mkEnableOption "VSCode configuration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixfmt
      nixd
      dprint
      material-icons
      material-design-icons
      act
    ];

    programs.vscode = {
      enable = true;

      profiles.default = {
        userSettings = {
          "files.autoSave" = "onFocusChange";
          "editor.fontSize" = 14;
          "editor.tabSize" = 4;
          "editor.renderWhitespace" = "selection";
          "editor.cursorStyle" = "line";
          "editor.multiCursorModifier" = "alt";
          "editor.insertSpaces" = true;
          "editor.wordWrap" = "off";
          "files.exclude" = {
            "**/.git" = true;
            "**/.svn" = true;
            "**/.hg" = true;
            "**/CVS" = true;
            "**/.DS_Store" = true;
            "**/Thumbs.db" = true;
          };
          "files.associations" = { };
          "keyboard.dispatch" = "keyCode";
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.startupEditor" = "none";
          "workbench.editor.enablePreview" = true;
          "window.autoDetectColorScheme" = false;
          "window.menuBarVisibility" = "toggle";
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "explorer.enableDragAndDrop" = false;
          "update.mode" = "none";
          "update.showReleaseNotes" = false;
          "material-icon-theme.activeIconPack" = "react";
          "material-icon-theme.files.associations" = {
            "*.ts" = "typescript";
            "**.json" = "json";
            "filename.tsx" = "react";
            "fileName.ts" = "typescript";
            "justfile" = "template";
          };
          "material-icon-theme.folders.associations" = {
            ".direnv" = "Generator";
            "applications" = "App";
            "flake" = "Project";
            "home-manager" = "Home";
            "homes" = "Home";
            "hosts" = "Decorators";
            "hyprland" = "Theme";
            "laptop" = "Desktop";
            "MinecraftModpack" = "Minecraft";
            "nas" = "Context";
            "nixos" = "Project";
            "overlays" = "Content";
            "parts" = "Components";
            "profiles" = "Content";
            "steam" = "Console";
            "systems" = "Decorators";
            "user0" = "Guard";
            "user0/configs" = "Client";
            "user1" = "Private";
            "user1/configs" = "Client";
            "user2" = "Private";
            "user2/configs" = "Client";
            "users" = "Global";
            "work" = "Desktop";
          };
          "lldb.suppressUpdateNotifications" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = true;
          };
          "[typescript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = true;
          };
          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = true;
          };
          "gitlens.telemetry.enabled" = false;
          "gitlens.ai.experimental.model" = "openai:gpt-3.5-turbo";
          "gitlens.experimental.generateCommitMessagePrompt" =
            "Generate a commit message using the Conventional Commits format. Examples: ['feat: Add new feature to the project', 'fix: Fix a bug in the project', 'chore: Update build configuration or task', 'docs: Update project documentation', 'style: Update code formatting or style', 'refactor: Refactor existing code', 'test: Add or update tests', 'perf: Improve performance of the project', 'ci: Update continuous integration configuration', 'build: Make changes related to the build process', 'revert: Revert a previous commit']";
          "github.copilot.enable" = {
            "*" = false;
          };
          "cSpell.customDictionaries" = {
            "custom-dictionary-user" = {
              "name" = "custom-dictionary-user";
              "path" = "~/.cspell/custom-dictionary-user.txt";
              "addWords" = true;
              "scope" = "user";
            };
          };
          "vscode-ollama.baseUrl" = "http://desktop:11434";
          "vscode-ollama.model" = "qwen2.5-coder:latest";
          "gitlens.ai.ollama.url" = "http://desktop:11434";
          "ollama-autocoder.endpoint" = "http://desktop:11434/api/generate";
          "ollama-autocoder.model" = "qwen2.5-coder:latest";
          "extensions.experimental.affinity" = {
            "jasew.vscode-helix-emulation" = 1;
          };
          "json.schemaDownload.trustedDomains" = {
            "https://schemastore.azurewebsites.net/" = true;
            "https://raw.githubusercontent.com/" = false;
            "https://www.schemastore.org/" = true;
            "https://json.schemastore.org/" = true;
            "https://json-schema.org/" = true;
            "https://plugins.dprint.dev" = true;
          };
        };

        extensions =
          with pkgs.vscode-extensions;
          [
            continue.continue
            eamodio.gitlens
            esbenp.prettier-vscode
            github.vscode-github-actions
            james-yu.latex-workshop
            jnoortheen.nix-ide
            marp-team.marp-vscode
            mattn.lisp
            mkhl.direnv
            ms-azuretools.vscode-docker
            myriad-dreamin.tinymist
            pkief.material-icon-theme
            pkief.material-product-icons
            rust-lang.rust-analyzer
            signageos.signageos-vscode-sops
            streetsidesoftware.code-spell-checker
            tamasfe.even-better-toml
            thenuprojectcontributors.vscode-nushell-lang
            wakatime.vscode-wakatime
            yzhang.markdown-all-in-one
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-helix-emulation";
              publisher = "jasew";
              version = "0.7.0";
              sha256 = "sha256-gYyIVnXG9Atmik0c1FsRKO2idFnufwl26nOiH3DYPLY=";
            }
            {
              name = "github-local-actions";
              publisher = "SanjulaGanepola";
              version = "1.2.5";
              sha256 = "sha256-gc3iOB/ibu4YBRdeyE6nmG72RbAsV0WIhiD8x2HNCfY=";
            }
          ];
      };
    };
  };
}
