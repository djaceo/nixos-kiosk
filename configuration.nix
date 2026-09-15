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

  services.cage = {
    enable = true;
    user = "kiosk";

    program = "${pkgs.chromium}/bin/chromium --kiosk --incognito --start-fullscreen https://www.google.de";
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}