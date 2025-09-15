# /hosts/ChisakaAiri/default.nix
{ config, pkgs, ... }:

{
  imports = [
    # Import the base configuration common to all servers
    ../../modules/base.nix
  ];

  # --- System Configuration ---
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ChisakaAiri";
  networking.useDHCP = true;
  
  # --- ZFS Support ---
  # These settings are required for a ZFS root filesystem
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;
  # A unique host ID is required for ZFS. This can be any 8-digit hex number.
  networking.hostId = "c51a9a81";


  # --- Docker & Grist Configuration (Unchanged) ---
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