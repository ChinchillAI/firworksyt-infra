{
  disko.devices = {
    disk.vda = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = { size = "1G"; type = "EF00"; content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; }; };
          zfs = {
            size = "100%";
            content = {
              type = "zfs_pool";
              pool = "rpool";
              datasets = {
                "root" = { type = "zfs_fs"; mountpoint = "none"; };
                "data" = { type = "zfs_fs"; mountpoint = "none"; };
                "nixos" = { type = "zfs_fs"; mountpoint = "/"; postCreateHook = "zfs set atime=off rpool/nixos"; };
                "nix" = { type = "zfs_fs"; mountpoint = "/nix"; postCreateHook = "zfs set atime=off rpool/nix"; };
                "home" = { type = "zfs_fs"; mountpoint = "/home"; };
              };
              rootFsOptions = { compression = "lz4"; xattr = "sa"; acltype = "posixacl"; };
            };
          };
        };
      };
    };
  };
}