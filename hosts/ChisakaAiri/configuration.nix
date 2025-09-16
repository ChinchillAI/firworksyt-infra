{ config, pkgs, lib, ... }:

{
  imports = [
    ./disko.nix
  ];

  networking.hostName = "ChisakaAiri";

  # ZFS basics
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs = {
    autoScrub.enable = true;
    autoScrub.pools = [ "rpool" ];
    trim.enable = true;
  };

  # Generate an 8-hex hostId once and paste it here (e.g. `openssl rand -hex 4`)
  networking.hostId = "REPLACE_ME_8_HEX";

  # Bootloader & EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time & firewall
  time.timeZone = "America/Chicago";
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 8484 ];

  # Users
  users.mutableUsers = false;
  users.users.firworks = {
    isNormalUser = true;
    description = "firworks";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDh73Zy1ZaxjjLEIS61b4PSqBmQjgNSk0RGV4nwTeHm0 firworks@nixpad"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  # SSH hardening
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Swap: use zram instead of a zvol by default
  zramSwap.enable = true;

  # Containers: Docker backend + oci-containers
  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers = {
        grist = {
          image = "gristlabs/grist:latest";
          ports = [ "0.0.0.0:8484:8484" ];
          volumes = [
            "/var/lib/grist:/persist"
          ];
          environment = {
            GRIST_SESSION_SECRET = "REPLACE_WITH_RANDOM_64_CHARS";
            # For Postgres later:
            # GRIST_DB_URI = "postgresql://grist:password@db/grist";
          };
          extraOptions = [ "--restart=unless-stopped" ];
        };
      };
    };
  };

  # Optional: simple HTTPS front-end later (uncomment & point DNS)
  # services.caddy = {
  #   enable = true;
  #   virtualHosts."grist.your-domain.com".extraConfig = ''
  #     reverse_proxy 127.0.0.1:8484
  #   '';
  # };
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  environment.systemPackages = with pkgs; [
    vim git curl htop jq
    smartmontools
    docker-compose
    zfs
  ];

  system.stateVersion = "24.11";
}
