# IMPORTANT: This flake intentionally has ZERO inputs.
#
# nixpkgs is imported via fetchTarball in nix/nixpkgs.nix, bypassing the
# flake input system. This is critical for `nix develop` performance:
#
#   - Each flake input adds ~1.5s of fetcher-cache verification on cold
#     eval cache. Even a single nixpkgs input costs ~7s.
#   - With zero inputs, `nix develop` cold is ~2.6s, warm is ~0.3s.
#
# DO NOT add flake inputs (nixpkgs, flake-parts, git-hooks, etc.).
# Instead, use fetchTarball or callPackage in nix/ files.
{
  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      outputSystems = lib.systems.flakeExposed;
      cachedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      devSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems =
        systems: fn:
        lib.genAttrs systems (
          system:
          fn (
            import ./nix/nixpkgs.nix {
              inherit system;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "python3.13-beaker-1.13.0"
                ];
              };
            }
          )
        );

      mkModule =
        {
          name ? "default",
          class,
          file,
        }:
        {
          _class = class;
          _file = "${self.outPath}/flake.nix#${class}Modules.${name}";

          imports = [ (import file { jqpkgsSelf = self; }) ];
        };
    in
    {
      # Taken from [1]:
      # [1]: https://github.com/tgirlcloud/pkgs/blob/af24043ecab1f86ad89eca849ce28ebffcc4eca7/flake.nix#L52
      packages = forAllSystems outputSystems (
        pkgs:
        lib.filterAttrs (
          _: pkg:
          let
            isDerivation = lib.isDerivation pkg;
            availableOnHost = lib.meta.availableOn pkgs.stdenv.hostPlatform pkg;
            isBroken = pkg.meta.broken or false;
          in
          isDerivation && !isBroken && availableOnHost
        ) self.legacyPackages.${pkgs.stdenv.hostPlatform.system}
      );

      legacyPackages = forAllSystems outputSystems (pkgs: import ./default.nix { inherit pkgs; });

      # Taken from [1]:
      # [1]: https://github.com/tgirlcloud/pkgs/blob/af24043ecab1f86ad89eca849ce28ebffcc4eca7/flake.nix#L68
      hydraJobs = forAllSystems cachedSystems (
        pkgs:
        lib.filterAttrs (
          _: pkg:
          let
            isDerivation = lib.isDerivation pkg;
            availableOnHost = lib.meta.availableOn pkgs.stdenv.hostPlatform pkg;
            isCross = pkg.stdenv.buildPlatform != pkg.stdenv.targetPlatform;
            isBroken = pkg.meta.broken or false;
            isCacheable = !(pkg.preferLocalBuild or false);
          in
          isDerivation && (availableOnHost || isCross) && !isBroken && isCacheable
        ) self.legacyPackages.${pkgs.stdenv.hostPlatform.system}
      );
      # Taken from [1] which attributes [2]:
      # [1]: https://github.com/tgirlcloud/pkgs/blob/e44955254a9d1eed2d4e4e12c6feb39cb8154638/flake.nix#L85
      # [2]: https://github.com/lilyinstarlight/nixos-cosmic/blob/0b0e62252fb3b4e6b0a763190413513be499c026/flake.nix#L81
      apps = forAllSystems devSystems (pkgs: {
        update = {
          type = "app";
          meta.description = "Script to execute nix-update-script and commit changes";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "update";
              text = lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  name: pkg:
                  if pkg ? updateScript && (lib.isList pkg.updateScript) then
                    lib.escapeShellArgs (
                      if (lib.match "nix-update|.*/nix-update" (lib.head pkg.updateScript) != null) then
                        pkg.updateScript
                        ++ [
                          "--commit"
                          name
                        ]
                      else
                        pkg.updateScript
                    )
                  else
                    toString pkg.updateScript or "# no update script for ${name}"
                ) self.legacyPackages.${pkgs.stdenv.hostPlatform.system}
              );
            }
          );
        };
      });

      devShells = forAllSystems devSystems (pkgs: {
        default = pkgs.callPackage ./shell.nix { };
      });

      formatter = forAllSystems devSystems (pkgs: pkgs.nixfmt-tree);

      overlays.default = _: prev: import ./default.nix { pkgs = prev; };

      nixosModules.default = mkModule {
        class = "nixos";
        file = ./modules/nixos;
      };

      homeModules.default = mkModule {
        class = "homeManager";
        file = ./modules/home-manager;
      };

      templates.rust-project = {
        path = ./templates/rust-project;
        description = ''
          Opinionated Rust project with npins zero-inputs, nix devshell, and
          agentic workflows'';
      };
      templates.typescript-node = {
        path = ./templates/typescript-node;
        description = ''
          Opinionated Typescript node template starter with npins
          zero-inputs, nix devshell, basic eslint typescript
          configuration and mocha/chai test build. Supports both
          CommonJS and EMS builds by default.'';
      };
    };
}
