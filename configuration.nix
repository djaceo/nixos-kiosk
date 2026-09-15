{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "nixos-kiosk";

  networking.networkmanager.enable = true;

  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk User";
    extraGroups = [
      "networkmanager"
    ];
    initialPassword = "test";
  };

  programs.chromium = {
    enable = true;

    extraOpts = {
      DownloadRestrictions = 3;
      PrintingEnabled = false;
    };
  };

  environment.systemPackages = with pkgs; [
    chromium
    cage
  ];

  environment.etc."kiosk/start-browser.sh" = {
    source = ./start-browser.sh;
    mode = "0755";
  };

  services.cage = {
    enable = true;
    user = "kiosk";

    program = "/etc/kiosk/start-browser.sh";
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}