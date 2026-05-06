# agents

Agent configuration managed by [APM](https://microsoft.github.io/apm/).

## Recipes (`just ai::*`)

| Recipe | Purpose |
|---|---|
| `just ai` | Install APM config + launch coding agent |
| `just ai::apm` | Deploy APM primitives to agent runtime directories |
| `just ai::apm-update` | Advance locked deps to latest refs (all, or `<package>`) |
| `just ai::apm-audit` | Security audit (Unicode, lockfile consistency) |

Set `AI_AGENT` to override the default agent launcher.

## MCP Servers

MCP servers are declared in `agents/apm.yml` and installed by `apm install`.
They must be packaged as nix derivations available in the devShell PATH.

The source of truth is `apm.yml` + `.apm/`. Edit sources there, run `just ai::apm`, and commit the result.
