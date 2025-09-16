{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
            size = "100%";
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
      };
      rootFsOptions = {
        acltype = "posixacl";
        xattr = "sa";
        relatime = "on";
        compression = "lz4";
        dnodesize = "auto";
        normalization = "formD";
        mountpoint = "none";
        canmount = "off";
        devices = "off";
      };
      datasets = {
        "root" = {
          type = "zfs_fs";
          mountpoint = "/";
          options = {
            mountpoint = "legacy";
          };
        };
        "home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            mountpoint = "legacy";
          };
        };
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            mountpoint = "legacy";
            atime = "off";
          };
        };
        "var" = {
          type = "zfs_fs";
          mountpoint = "/var";
          options = {
            mountpoint = "legacy";
          };
        };
        "var/lib" = {
          type = "zfs_fs";
          mountpoint = "/var/lib";
          options = {
            mountpoint = "legacy";
          };
        };
        "var/lib/grist" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/grist";
          options = {
            mountpoint = "legacy";
            recordsize = "128K";
          };
        };
        "var/lib/docker" = {
          type = "zfs_fs";
          mountpoint = "/var/lib/docker";
          options = {
            mountpoint = "legacy";
          };
        };
        # Optional: a place for other app state
        "persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            mountpoint = "legacy";
          };
        };
      };
    };
  };
}
