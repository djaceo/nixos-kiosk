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

  environment.etc."kiosk/start-browser.sh" = {
    source = ./start-browser.sh;
    mode = "0755";
  };

  systemd.user.services.chromium-kiosk = {
    description = "Start Chromium kiosk browser";

    wantedBy = [ "graphical-session.target" ];

    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "/etc/kiosk/start-browser.sh";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}