{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aider;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate ".aider.conf.yml" cfg.settings;
in
{
  options.programs.aider = {
    enable = mkEnableOption "AI pair programming tool";

    package = mkOption {
      type = types.package;
      default = pkgs.aider-chat;
      description = "The package to use for aider";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = "Aider configuration settings";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];

      file.".aider.conf.yml".source = mkIf (cfg.settings != { }) settingsFile;
    };
  };
}
