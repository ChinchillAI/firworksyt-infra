# /modules/base.nix
{ config, pkgs, ... }:

{
  # Set your time zone
  time.timeZone = "America/Chicago";

  # Standard base packages for every server
  environment.systemPackages = with pkgs; [
    nano
    git
    curl
    wget
  ];

  # Define your user account
  users.users.firworks = {
    isNormalUser = true;
    # Add user to the 'wheel' group for sudo and 'docker' for docker CLI access
    extraGroups = [ "wheel" "docker" ];
    # This is the crucial part for passwordless SSH access
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDh73Zy1ZaxjjLEIS61b4PSqBmQjgNSk0RGV4nwTeHm0 firworks@nixpad"
    ];
  };

  # Security: Disable password-based SSH login entirely. Only keys will work.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.11"; # Change to "24.05" when it releases
}