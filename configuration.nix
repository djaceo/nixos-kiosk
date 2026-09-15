{ config, pkgs, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "nixos-kiosk";
  networking.networkmanager.enable = true;

  # ------------------------------------------------------------
  # Sprache / Tastatur
  # ------------------------------------------------------------

  i18n.defaultLocale = "de_DE.UTF-8";

  services.xserver.xkb.layout = "de";


  # ------------------------------------------------------------
  # Benutzer
  # ------------------------------------------------------------

  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk User";

    extraGroups = [
      "networkmanager"
    ];

    initialPassword = "test";
  };

  # Wartungsbenutzer:
  # erreichbar über Ctrl+Alt+F3
  users.users.maintenance = {
    isNormalUser = true;
    description = "Wartung";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    initialPassword = "test";
  };


  # ------------------------------------------------------------
  # Chromium
  # ------------------------------------------------------------

  programs.chromium = {
    enable = true;

    extraOpts = {

      # --------------------------------------------------------
      # Downloads vollständig sperren
      # --------------------------------------------------------

      DownloadRestrictions = 3;


      # --------------------------------------------------------
      # Datei öffnen / hochladen / speichern verhindern
      # --------------------------------------------------------

      AllowFileSelectionDialogs = false;


      # --------------------------------------------------------
      # Drucken sperren
      # --------------------------------------------------------

      PrintingEnabled = false;


      # --------------------------------------------------------
      # Passwortmanager sperren
      # --------------------------------------------------------

      PasswordManagerEnabled = false;
      PasswordManagerAllowShowPasswords = false;


      # --------------------------------------------------------
      # Autofill sperren
      # --------------------------------------------------------

      AutoFillEnabled = false;


      # --------------------------------------------------------
      # Erweiterungen sperren
      # --------------------------------------------------------

      ExtensionInstallBlocklist = [
        "*"
      ];


      # --------------------------------------------------------
      # Entwicklertools sperren
      # --------------------------------------------------------

      DeveloperToolsAvailability = 2;


      # --------------------------------------------------------
      # Keine zusätzlichen Browserprofile
      # --------------------------------------------------------

      BrowserAddPersonEnabled = false;
      BrowserGuestModeEnabled = false;


      # --------------------------------------------------------
      # Ausschließlich Inkognito
      # --------------------------------------------------------

      IncognitoModeAvailability = 2;


      # --------------------------------------------------------
      # Cast / Streamen deaktivieren
      # --------------------------------------------------------

      EnableMediaRouter = false;


      # --------------------------------------------------------
      # "Speichern und teilen" / Sharing Hub deaktivieren
      # --------------------------------------------------------

      DesktopSharingHubEnabled = false;


      # --------------------------------------------------------
      # Browserdaten nicht dauerhaft behalten
      # Zusätzliche Absicherung neben Inkognito
      # --------------------------------------------------------

      SavingBrowserHistoryDisabled = true;


      # --------------------------------------------------------
      # Interne Chromium-Seiten sperren
      # --------------------------------------------------------

      URLBlocklist = [
        "chrome://settings/*"
        "chrome://downloads/*"
        "chrome://extensions/*"
        "chrome://password-manager/*"
        "chrome://history/*"
        "chrome://bookmarks/*"
        "chrome://autofill/*"
        "chrome://flags/*"
        "chrome://inspect/*"
        "chrome://components/*"
        "chrome://system/*"
        "chrome://gpu/*"
        "chrome://webrtc-internals/*"
        "chrome://media-internals/*"
      ];
    };
  };


  # ------------------------------------------------------------
  # Installierte Pakete
  # ------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    chromium
    cage
  ];


  # ------------------------------------------------------------
  # Browser-Startscript
  # ------------------------------------------------------------

  environment.etc."kiosk/start-browser.sh" = {
    source = ./start-browser.sh;
    mode = "0755";
  };


  # ------------------------------------------------------------
  # Cage Kiosk
  # ------------------------------------------------------------

  services.cage = {
    enable = true;

    user = "kiosk";

    # VT-Wechsel erlauben:
    # Ctrl+Alt+F2/F3/...
    extraArguments = [
      "-s"
    ];

    program = "/etc/kiosk/start-browser.sh";
  };


  # ------------------------------------------------------------
  # Wartungs-TTY
  # ------------------------------------------------------------

  systemd.services."getty@tty3".enable = true;
}