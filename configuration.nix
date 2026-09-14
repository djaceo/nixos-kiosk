{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "nixos-kiosk";

  networking.networkmanager.enable = true;

  services.xserver.enable = true;

  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.displayManager.lightdm.enable = true;

  services.displayManager.defaultSession = "xfce";

  services.xserver.xkb.layout = "de";

  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk Test User";
    extraGroups = [
      "wheel"
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
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}