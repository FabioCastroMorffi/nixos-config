{ self, inputs, ... }: {
  flake.nixosModules.bootIntro =
    { config, pkgs, ... }:
    let
      videoPath = ./intro.mp4;

      bootIntroScript = pkgs.writeShellScript "boot-intro" ''
        clear > /dev/tty1

        ${pkgs.mpv}/bin/mpv \
          --vo=drm \
          --drm-connector="HDMI-A-1" \
          # --audio-device="alsa/hdmi:CARD=HDMI,DEV=8" \
          --audio-device="alsa/hdmi:CARD=Generic,DEV=0"
          # --audio-device="alsa/hw:0,8"
          --fs \
          --no-border \
          --osc=no \
          --input-default-bindings=no \
          --keep-open=no \
          --msg-level=all=no \
          "${videoPath}"
      '';
    in
    {
      systemd.services.boot-intro = {
        description = "Play boot intro video";

        restartIfChanged = false;
        stopIfChanged = false;

        wants = [ "systemd-udev-settle.service" ];
        after = [
          "systemd-udev-settle.service"
          "systemd-user-sessions.service"
          "sound.target"
        ];

        wantedBy = [ "multi-user.target" ];
        before = [ "display-manager.service" ];
        conflicts = [ "getty@tty1.service" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${bootIntroScript}";
          StandardInput = "tty";
          StandardOutput = "tty";
          TTYPath = "/dev/tty1";
          TTYReset = true;
          TTYVHangup = true;
          SupplementaryGroups = [
            "video"
            "render"
            "audio"
          ];
        };
      };
    };
}
