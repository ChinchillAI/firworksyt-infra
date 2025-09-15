# /hosts/ChisakaAiri/disko-config.nix
{ disko, ... }:

{
  imports = [ disko.nixosModules.disko ];

  disko.devices = {
    disk.vda = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # EFI boot partition is still required for UEFI boot
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          # ZFS partition takes up the rest of the disk
          zfs = {
            size = "100%";
            content = {
              type = "zfs_pool";
              pool = "rpool"; # The name of our root pool
              # ZFS datasets are defined here
              datasets = {
                # These are "blank" datasets that hold the mounted ones
                # This allows for easier snapshotting and management
                "root" = {
                  type = "zfs_fs";
                  mountpoint = "none";
                };
                "data" = {
                  type = "zfs_fs";
                  mountpoint = "none";
                };
                # The actual mounted datasets
                "nixos" = {
                  type = "zfs_fs";
                  mountpoint = "/";
                  postCreateHook = "zfs set atime=off rpool/nixos";
                };
                "nix" = {
                  type = "zfs_fs";
                  mountpoint = "/nix";
                  postCreateHook = "zfs set atime=off rpool/nix";
                };
                "home" = {
                  type = "zfs_fs";
                  mountpoint = "/home";
                };
              };
              # Set some sane default options for the entire pool
              rootFsOptions = {
                compression = "lz4";
                xattr = "sa";
                acltype = "posixacl";
              };
            };
          };
        };
      };
    };
  };
}