# Run recipes from project root, not agents/
set working-directory := '..'

apm_cmd := 'uvx --from git+https://github.com/microsoft/apm apm'

# Deploy APM primitives to .opencode/ (rules, commands, skills, hooks)
apm:
    {{ apm_cmd }} install -t opencode

# Advance locked APM dependencies to latest refs (all, or specific packages)
apm-update *packages:
    {{ apm_cmd }} deps update {{ packages }}

# Audit APM packages for security issues (Unicode, lockfile consistency)
apm-audit:
    {{ apm_cmd }} audit --ci -t opencode

# Verify vendored .opencode/ matches .apm/ sources + security audit
apm-sync: apm apm-audit
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain .opencode/)" ]; then
        echo "ERROR: .opencode/ out of sync with .apm/ — run: just ai::apm"
        git status .opencode/
        exit 1
    fi

# Install APM config and launch coding agent (AI_AGENT overrides default)
[default]
agent *args: apm
    {{ env('AI_AGENT', 'opencode') }} {{ args }}
