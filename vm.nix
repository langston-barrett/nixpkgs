# export NIX_PATH=nixpkgs=$PWD:nixos-config=./configuration.nix
# nixos-rebuild build-vm -I $PWD -I nixos-config=./vm.nix
# useradd -g 100 untrusted
# mkdir /home/untrusted
# chown untrusted /home/unstrusted
# su untrusted
# echo "#!/usr/bin/env bash" > /home/untrusted/script.sh
# echo "echo hey"            > /home/untrusted/script.sh
{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gcc
  ];

  i18n = {
    # Use a bigger font for HiDPI displays
    consoleFont = "sun12x22";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  services.chrony.enable = true;
  time.timeZone = "USA/Los_Angeles";

  nix = {
    maxJobs = 4;
    buildCores = 4;
    gc.automatic = true;
    useSandbox = true;
  };

  networking = {
    hostName = "nova-nixos-vm";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    networkmanager.enable = true;
  };

  security.sudo.enable = true;
  users = {
    users = {
      siddharthist = {
        isNormalUser = true;
        home = "/home/siddharthist";
        createHome = true;
        password = "password";
        description = "Langston Barrett";
        uid = 1000;
        group = "siddharthist";
        extraGroups = [ "wheel" "networkmanager" ];
      };
      untrusted = {
        isNormalUser = true;
        home = "/home/untrusted";
        createHome = true;
        password = "password";
        description = "untrusted user";
        uid = 100;
        group = "untrusted";
        extraGroups = [ "untrusted" ];
      };
    };
  };

  security.grsecurity = {
    enable = true;
    disableEfiRuntimeServices = true;
    lockTunables = true;
    trustedPathExecution = {
      enable = true;
      partialRestriction = true;
    };
  };
}
