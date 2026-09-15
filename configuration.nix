{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "nixos-kiosk";
  networking.networkmanager.enable = true;

  # Deutsches System / deutsche Tastatur
  i18n.defaultLocale = "de_DE.UTF-8";

  services.xserver.xkb.layout = "de";

  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk User";
    extraGroups = [
      "networkmanager"
    ];
    initialPassword = "test";
  };

  # Separater Wartungsbenutzer für TTY
  users.users.maintenance = {
    isNormalUser = true;
    description = "Wartung";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "test";
  };

  programs.chromium = {
    enable = true;

    extraOpts = {
      # Downloads komplett verbieten
      DownloadRestrictions = 3;

      # Drucken komplett verbieten
      PrintingEnabled = false;

      # Chromium-Einstellungen blockieren
      URLBlocklist = [
        "chrome://settings/*"
      ];
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

    # Erlaubt Ctrl+Alt+F2/F3/... zum Wechseln auf eine Wartungs-TTY
    extraArguments = [
      "-s"
    ];

    program = "/etc/kiosk/start-browser.sh";
  };

  # Wartungs-TTY explizit aktivieren
  systemd.services."getty@tty3".enable = true;

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}