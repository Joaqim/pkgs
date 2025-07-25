{ config, lib, ... }:
let
  cfg = config.services.site-host;
in
{
  options.services.site-host = with lib; {
    enable = mkEnableOption "Simple systemd site-host";

    path = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = "Path dependencies for script";
    };

    script = mkOption {
      type = types.str;
      description = "Script to run";
    };

    restartIfChanged = mkEnableOption "Restart systemd service on configuration changes";
  };

  config = lib.mkIf cfg.enable {
    systemd.services."site-host" = {
      enable = true;
      restartIfChanged = true;
      after = [ "Network.service" ];
      wants = [ "Network.service" ];
      inherit (cfg) path script;
    };
  };
}
