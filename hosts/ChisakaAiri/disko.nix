{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "DISK_BY_ID_HERE";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512MiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            type = "BF01";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };

    zpool.rpool = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "on";
        compatibility = "grub2"; # Fine with systemd-boot too; mainly keeps features sane
      };
      rootFsOptions = {
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
        # mountpoints are defined per-dataset below
      };
      datasets = {
        "root" = {
          type = "zfs_fs";
          mountpoint = "/";
          options = { mountpoint = "legacy"; };
        };
        "home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = { mountpoint = "legacy"; };
        };
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = { mountpoint = "legacy"; atime = "off"; };
        };
        "var" = {
          type = "zfs_fs";
          mountpoint = "/var";
          options = { mountpoint = "legacy"; };
        };
        "var/lib" = {
          type = "zfs_fs";
          mountpoint = "/var/lib";
          options = { mountpoint = "legacy"; };
        };
        "var/lib/grist" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/grist";
          options = { mountpoint = "legacy"; recordsize = "128K"; };
        };
        "var/lib/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          options = { mountpoint = "legacy"; };
        };
        # Optional: a place for other app state
        "persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = { mountpoint = "legacy"; };
        };
      };
    };
  };
}
