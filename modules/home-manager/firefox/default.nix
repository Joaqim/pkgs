{ jqpkgs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.jqpkgs.firefox;
  user = config.home.username;
in
{
  options.jqpkgs.firefox = mkEnableOption "Firefox configuration";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.mpv-handler.override {
        mpv = "";
        yt-dlp = "";
      })
    ];

    programs.firefox = {
      enable = true;

      languagePacks = lib.mkDefault [
        "en-US"
        "sv-SE"
      ];

      nativeMessagingHosts = [ pkgs.ff2mpv ];

      policies = import ./config-jq/policies.nix { inherit lib; };

      profiles.${user} = mkIf (lib.pathExists ./config-${user}) {
        isDefault = true;
        search = import ./config-${user}/search.nix;
        bookmarks = import ./config-${user}/bookmarks.nix;
        settings = import ./config-${user}/settings.nix;
        extensions.packages = import ./config-${user}/extensions.nix {
          inherit
            pkgs
            jqpkgs
            ;
        };
        userChrome = builtins.readFile ./config-${user}/userChrome.css;
        userContent = ''
          .tab:not(:hover) .closebox {
            display: none;
          }
        '';
      };
    };

    xdg.mimeApps = {
      enable = lib.mkDefault true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };
}
