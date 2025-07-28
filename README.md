# jqpkgs

## Initial repository inspired by [github.com/tgirlcloud/pkgs](https://github.com/tgirlcloud/pkgs)

~~If you're reading the docs on the README.md file you can find the full documentation at [https://joaqim.github.io/pkgs](https://joaqim.github.io/pkgs).~~

## Installation

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

