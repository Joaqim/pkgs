---
description: Project-specific code-police rules for anylang-template
applyTo: '**'
---

## Code Police Rules

### no-nix-shell-commands

Never use shell commands in Nix derivations when Nix builtins or pkgs functions exist. Shell commands reduce reproducibility and make debugging harder.

### no-flake-inputs

This template intentionally uses zero flake inputs for performance. Do not add flake inputs (nixpkgs, flake-parts, etc.) to flake.nix. Use fetchTarball or callPackage in nix/ files instead.

### justfile-doc-comments

Every just recipe must have a doc comment above it explaining what it does.

### pre-commit-hooks-required

All projects using this template must have pre-commit hooks installed and configured. Never bypass or disable them.

### treefmt-over-formatters

Use treefmt for all formatting operations. Do not call formatters directly (dprint, nixpkgs-fmt) in just recipes. This ensures consistent formatting across the project.

### test-recipe-required

Every project must override the `test` recipe with actual test commands. The placeholder message is a build error waiting to happen.

### readme-updates

Update the main README.md when adding new workflows, packages, or significant features. Documentation should stay in sync with implementation.

### no-silent-error-swallowing

In shell scripts, never use `|| true` or empty catch blocks without explaining why. If error swallowing is intentional (best-effort operation), add a comment explaining the rationale.
