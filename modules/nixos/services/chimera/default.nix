{ jqpkgs }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.chimera;
in
{
  options.services.chimera = {
    enable = lib.mkEnableOption "Chimera web interface for managing Steam and emulators";

    enableSteamPatch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the steam-patch user service, which applies game tweaks and
        shortcuts to Steam. Requires chimera to be enabled.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = ''
        The user account under which the chimera and steam-patch user services
        will run. This user must exist on the system.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = jqpkgs.chimera;
      defaultText = lib.literalExpression "jqpkgs.chimera";
      description = "The chimera package to use.";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    # chimera-proxy is a system-level reverse proxy that fronts the user-level
    # chimera web service. It ships as both a .service and a .socket unit.
    systemd.services.chimera-proxy = {
      description = "Chimera reverse proxy";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/chimera-proxy";
        Restart = "on-failure";
      };
    };

    systemd.sockets.chimera-proxy = {
      description = "Chimera reverse proxy socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = 8844;
        Accept = false;
      };
    };

    # chimera.service and steam-patch.service are user-level units that must
    # run in the context of the gaming user's session (access to Steam, $HOME, etc.)
    systemd.user.services.chimera = {
      description = "Chimera web interface";
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/chimera";
        Restart = "on-failure";
        # Ensure chimera can write runtime state to XDG user dirs
        Environment = [
          "PATH=${lib.makeBinPath [ cfg.package ]}"
        ];
      };
    };

    systemd.user.services.steam-patch = lib.mkIf cfg.enableSteamPatch {
      description = "Steam game tweaks and patch applicator";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/steam-patch";
        Restart = "on-failure";
      };
    };

    # The user services above are defined globally but must be enabled for the
    # specific user. NixOS's systemd.user services are activated for all
    # loginctl-managed user sessions automatically when wantedBy default.target,
    # but we also ensure the user is a valid systemd loginctl user.
    users.users.${cfg.user} = {
      isNormalUser = lib.mkDefault true;
    };

    # udev rules shipped by chimera (e.g. for controller/NFC support)
    services.udev.packages = [ cfg.package ];
  };
}
