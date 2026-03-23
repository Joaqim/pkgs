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

    port = lib.mkOption {
      type = lib.types.port;
      default = 8844;
      description = "Port to use for the Chimera web interface.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = jqpkgs.packages.${pkgs.stdenv.hostPlatform.system}.chimera;
      defaultText = lib.literalExpression "jqpkgs.chimera";
      description = "The chimera package to use.";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    # TODO: Proxy is optional

    # chimera-proxy is a system-level reverse proxy that fronts the user-level
    # chimera web service. It ships as both a .service and a .socket unit.
    # Ideally, would make the web interface available at: http://chimeraos.local:8844
    systemd.services.chimera-proxy = {
      description = "Chimera reverse proxy";
      requires = [ "chimera-proxy.socket" ];
      after = [ "chimera-proxy.socket" ];
      requiredBy = [ "chimera-proxy.socket" ];
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${cfg.port}";
      };
    };

    systemd.sockets.chimera-proxy = {
      description = "Chimera reverse proxy socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = 80;
        Service = "chimera-proxy.service";
      };
    };

    # chimera.service and steam-patch.service are user-level units that must
    # run in the context of the gaming user's session (access to Steam, $HOME, etc.)
    systemd.user.services.chimera = {
      description = "Chimera web interface";
      wantedBy = [ "default.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStartPre = "${lib.getExe' pkgs.toybox "sleep"} 10";
        ExecStart = lib.getExe' cfg.package "chimera";
        Restart = "on-failure";
        # Might not be necessary when using wrapped derivation
        WorkingDirectory = "/home/${cfg.user}/.local/share"; # TODO: Use better solution
      };
    };

    # TODO: Expects $XDG_DATA_DIR/chimera/data/patch to exist
    systemd.user.services.steam-patch = lib.mkIf cfg.enableSteamPatch {
      description = "Steam game tweaks and patch applicator";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "steam-patch";
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
    # TODO
    #services.udev.packages = [ cfg.package ];
  };
}
