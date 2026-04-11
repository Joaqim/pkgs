# Prefix for commands that need a Nix devshell; empty if already inside one.

nix_shell := if env('IN_NIX_SHELL', '') != '' { '' } else { 'nix develop path:' + justfile_directory() + ' -c' }

mod ai 'agents/ai.just'

# List available recipes
default:
  @just --list

# Remove all gitignored files (node_modules, build artifacts, etc.)
clean:
  git clean -fdX

# Lint
fmt:
    nix fmt

# Check formatting without modifying files (used by CI)
# nix fmt doesn't have check: https://github.com/NixOS/nix/issues/6918
fmt-check:
  {{ nix_shell }} sh -c "git ls-files '*.nix' | xargs nixfmt --check"

# Run all flake checks
check:
    nix flake check -L

docs:
  nix build -L ./docs#jqpkgs-docs

dev:
  @just docs
  {{ nix_shell }} simple-http-server -i result

update:
  nix run .#update
