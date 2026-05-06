# jqpkgs

Nix flake package collection and project templates.

## Templates

Instantiate a new project from a template:

```sh
mkdir my-project && cd my-project
nix flake init -t github:Joaqim/pkgs#rust-project
```

### rust-project

Opinionated Rust project scaffold with npins zero-inputs, nix devshell, and agentic workflows via APM.

- Zero flake inputs — all dependencies pinned via [npins](https://github.com/andir/npins) for fast `nix develop` (~1s cold, ~0.1s warm).
- Nix devshell with Rust toolchain (stable, configurable to nightly), `apm`, and `cargo-watch`.
- [APM](https://microsoft.github.io/apm/) agent configuration with opinionated skill dependencies (cargo-watch, nix-justfile, nix-ci, nix-flake, code-police, rust-development, cargo-nextest).
- [justfile](https://github.com/casey/just) recipes for build, run, test, fmt, watch, and AI agent management.

After instantiating, update pins and enter the devshell:

```sh
git init && git add -A
npins update
nix develop
```

## Installation

Repository structure inspired by [tgirlcloud/pkgs](https://github.com/tgirlcloud/pkgs).

You can use this as either a flake or with channels.

```nix
{
  inputs = {
    /* 
      your other inputs
    */
    jqpkgs.url = "github:Joaqim/pkgs";
  };
}
```

### Using the modules

You can import the modules like so:

```nix
{ inputs, ... }:
{
  # Whichever you need, modules for nixos and/or home manager
  imports = [
    inputs.jqpkgs.nixosModules.default
    inputs.jqpkgs.homeManagerModules.default
  ];
}
```

### Using packages with overlay ( recommended )

You can add the overlay like so:

```nix
{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.jqpkgs.overlays.default
  ];

  # then you can use the packages like normal
  environment.systemPackages = [
    pkgs.packagename
  ];
}
```

### Using packages directly

Manually import package by attribute path for your specific system

```nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.jqpkgs.packages.${pkgs.stdenv.hostPlatform.system}.packagename
    # Or:
    inputs.jqpkgs.packages."x86_64-linux".packagename
  ];
}
```

