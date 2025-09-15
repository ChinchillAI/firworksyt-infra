{ config, pkgs, disko, ... }:

{
  imports = [
    # Base config for users/ssh
    ../../modules/base.nix

    # Disko modules for partitioning
    disko.nixosModules.disko
    disko.nixosModules.zfs

    # The actual disk layout
    ./disko-config.nix
  ];

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