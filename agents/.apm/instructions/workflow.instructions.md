---
description: Core workflow conventions — execute pipeline commands, CI, formatting, testing, git, feature discoverability, external libraries
applyTo: '**'
---

## Workflow

- Use `/do` to execute tasks end-to-end: sync → research → branch+PR → implement → check → docs → police → fmt → commit → test → CI → update-pr → done. Each step has a verification check.
- For standalone quality checks, run `/code-police` (includes rules checklist + fact-check + elegance passes).
- Run `just fmt` (formatting) before declaring done.
- **Prefer external libraries over hand-rolled code**: Use well-maintained React/NextJS libraries and components to reduce custom code surface area. Less code to maintain = fewer bugs.

## Execute Pipeline Commands

These commands are used by the `/do` workflow's check, fmt and test.

## Check command

`just check` - fast static-correctness ( `npm run typecheck` under the hood. ) Runs across the workspace.

## Format command

`just fmt`

## Test command

`npm test` — run only tests relevant to changed code paths.

## CI command

`npm run ci` — verify by checking exit code 0.

## Feature Discoverability (Tips)

When adding a new user-facing feature or shortcut, consider adding a tip so users discover it. See `tips.ts` and `useTips.ts` for the registry and API.

## Git

- Use [conventional commits](https://www.conventionalcommits.org/) (e.g. `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`).
