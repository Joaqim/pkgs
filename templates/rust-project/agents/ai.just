# Run recipes from project root, not agents/
set working-directory := '..'

# Enter nix develop only when not already inside it — mirrors the root
# justfile's pattern. `apm` lives in the devshell (see shell.nix), so
# these recipes need to enter it when invoked from a bare shell.
nix_shell := if env('IN_NIX_SHELL', '') != '' { '' } else { 'nix develop --accept-flake-config -c' }

apm_cmd := nix_shell + 'apm'

# Install APM integrations for coding agents defined in root apm.yml.
apm-install:
    {{ apm_cmd }} install

# Compile the shared instruction file for agent runtimes.
apm-compile:
    {{ apm_cmd }} compile

# Refresh all APM-managed artifacts needed by coding agents
apm: apm-install apm-compile

# Advance locked APM dependencies to latest refs (all, or specific packages)
apm-update *packages:
    {{ apm_cmd }} deps update {{ packages }}
    {{ just_executable() }} apm

# Audit APM packages for security issues
apm-audit:
    {{ apm_cmd }} audit --ci

# Install APM config and launch coding agent (AI_AGENT overrides default)
[default]
agent *args: apm
    just prepare
    {{ env('AI_AGENT', 'claude --dangerously-skip-permissions') }} {{ args }}
