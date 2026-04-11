{ jqpkgs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;

  cfg = config.jqpkgs.mpv;
in
{
  options.jqpkgs.mpv = {
    enable = mkEnableOption "mpv configuration";

    screenshotDirectory = mkOption {
      type = types.nullOr types.str;
      description = "mpv screenshot directory relative to home";
      default = "Pictures/mpv-screenshots";
    };

    screenshotTemplate = mkOption {
      type = types.nullOr types.str;
      description = "mpv screenshot template";
      default = "%F - [%P] (%#01n)";
    };
  };

  config = mkIf cfg.enable {
    home = {
      file."${cfg.screenshotDirectory}/.keep" = {
        enable = cfg.screenshotDirectory != null;
        text = "";
      };
      packages = [ pkgs.noto-fonts-color-emoji ];
    };

    programs.mpv = {
      enable = true;

      extraInput = ''
        Alt+r script-binding mpv-org-history/log_entry
        k script-binding mpv-skipsilence/toggle
      '';

      scripts =
        with pkgs;
        builtins.attrValues {
          inherit (mpvScripts)
            mpris
            sponsorblock
            uosc
            mpv-playlistmanager
            webtorrent-mpv-hook
            reload
            thumbfast
            thumbnail
            ;
          inherit (mpvScripts.builtins)
            autocrop
            autodeint
            ;
          inherit (mpvScripts.eisa01) smartskip;
          inherit (mpvScripts.occivink) blacklistExtensions;
          inherit (jqpkgs.packages.${pkgs.stdenv.hostPlatform.system})
            mpv-org-history
            mpv-skipsilence
            ;
        };

      config = {
        profile = "gpu-hq";
        display-fps-override = 100;
        demuxer-max-bytes = "512MiB";
        demuxer-readahead-secs = 600;
        resume-playback = "yes";
        save-position-on-quit = "yes";
        image-display-duration = 5;
        af-add = "scaletempo2";
        alang = "jap,jp,eng,en,us,original";
        slang = "eng,en,us";
        osc = "no";
        screenshot-dir = "~/${cfg.screenshotDirectory}";
        screenshot-template = cfg.screenshotTemplate;
        ytdl-raw-options = lib.concatStringsSep "," [
          "sub-lang=en"
          "write-sub="
          "write-auto-sub="
        ];
        sub-font = "Noto Color Emoji";
        video-sync = "display-resample";
        vo = "gpu-next";
        watch-later-options = lib.concatStringsSep "," [
          "start"
          "volume"
          "mute"
          "playlist"
          "speed"
        ];
      };

      scriptOpts = {
        reload.reload_eof_enabled = "yes";
        ytdl_hook.ytdl_path = lib.getExe pkgs.yt-dlp;
      };

      profiles = {
        "twitch.tv" = {
          profile-cond = ''get("path", ""):find("^https://www.twitch.tv/(.*)") ~= nil'';
          profile-restore = "copy";
        };
        "watch.dropout.tv" = {
          profile-cond = ''get("path", ""):find("^https://.*dropout.tv/(.*)") ~= nil'';
          profile-restore = "copy";
          ytdl-raw-options-append = "cookies-from-browser=firefox";
        };
        "youtube.com" = {
          profile-cond = ''get("path", ""):find("^https://youtube.com/(.*)") ~= nil'';
          profile-restore = "copy";
          ytdl-raw-options-append = "cookies-from-browser=firefox,cookies=~/tmp/cookies.firefox-private.txt,extractor-args='youtube:player_js_version=actual'";
        };
      };
    };

    xdg.mimeApps.defaultApplications."x-scheme-handler/mpv" = "mpv.desktop";
  };
}
