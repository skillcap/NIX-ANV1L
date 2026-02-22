{ pkgs, ... }:

{
  home.packages = [ pkgs.rclone ];

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Mount Google Drive via Rclone";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive \
          --config=%h/.config/rclone/rclone.conf \
          --vfs-cache-mode writes
      '';
      ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
