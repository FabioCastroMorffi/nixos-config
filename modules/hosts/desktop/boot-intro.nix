{ config, pkgs, ... }:

let
  videoPath = "/home/fabio/not_my_clones/Tenna-intro-for-linux/intro.mp4";

  bootIntroScript = pkgs.writeShellScript "boot-intro" ''
    clear > /dev/tty1
    export AUDIODEV="hw:0,0"
    ${pkgs.mpv}/bin/mpv \
      --vo=drm \
      --drm-connector="HDMI-A-1" \
      --ao=alsa \
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
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];   # remove this line if you don't run a display manager
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${bootIntroScript}";
      RemainAfterExit = true;
      StandardInput = "tty";
      TTYPath = "/dev/tty1";
      # mpv needs GPU + audio device access:
      SupplementaryGroups = [ "video" "render" "audio" ];
    };
  };
}
