{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.autoscreen;
  defaultPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.services.autoscreen = {
    enable = lib.mkEnableOption "autoscreen, periodic automatic screenshots";

    package = lib.mkOption {
      type = lib.types.package;
      default = defaultPackage;
      defaultText = lib.literalExpression "autoscreen.packages.\${system}.default";
      description = "The autoscreen package to use.";
    };

    destinationDir = lib.mkOption {
      type = lib.types.str;
      default = "%h/Nextcloud/07_Images/01_autoscreen";
      description = ''
        Directory in which screenshots are stored. A dated subdirectory is
        created for each day.

        Use the systemd `%h` specifier for the user's home directory rather
        than `$HOME`: systemd expands `%h` in `Environment=`, but not `$HOME`.
      '';
    };

    filenameSuffix = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "nixos_";
      description = "String inserted just before `autoscreen.png` in screenshot file names.";
    };

    onCalendar = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = "systemd calendar expression for the screenshot timer.";
    };

    randomizedDelaySec = lib.mkOption {
      type = lib.types.either lib.types.int lib.types.str;
      default = 3600;
      description = "Randomized delay added to each scheduled run, in seconds.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.autoscreen = {
      Unit = {
        Description = "autoscreen - take a screenshot";
      };
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe cfg.package;
        Environment = [
          "AUTOSCREEN_DESTINATION_DIR=${cfg.destinationDir}"
          "AUTOSCREEN_FILENAME_SUFFIX=${cfg.filenameSuffix}"
        ];
      };
    };

    systemd.user.timers.autoscreen = {
      Unit = {
        Description = "Run autoscreen every hour at a random time";
      };
      Timer = {
        OnCalendar = cfg.onCalendar;
        RandomizedDelaySec = cfg.randomizedDelaySec;
        AccuracySec = "1us";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
