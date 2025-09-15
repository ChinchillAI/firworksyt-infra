{ config, pkgs, disko, ... }:

{
  imports = [
    # Base config for users/ssh
    ../../modules/base.nix

    # The one and only disko module needed
    disko.nixosModules.disko
  ];

  # DISK CONFIGURATION IS NOW DIRECTLY IN THIS FILE
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

  # --- System Configuration ---
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ChisakaAiri";
  networking.useDHCP = true;
  
  # --- ZFS Support ---
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;
  networking.hostId = "c51a9a81";

  # --- Docker & Grist Configuration ---
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.containers.grist = {
    image = "gristlabs/grist:latest";
    autoStart = true;
    ports = [ "8484:8484" ];
    volumes = [ "/var/lib/grist:/persist" ];
    environment = {};
  };

  # Open the firewall for SSH and Grist
  networking.firewall.allowedTCPPorts = [ 22 8484 ];
}