{ config, lib, pkgs, ... }:

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
  # Kiosk-Benutzer
  # ------------------------------------------------------------

  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk User";

    extraGroups = [
      "networkmanager"
    ];

    initialPassword = "test";
  };


  # ------------------------------------------------------------
  # Wartungsbenutzer
  # ------------------------------------------------------------

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
  # Chromium Enterprise Policies
  # ------------------------------------------------------------

  programs.chromium = {
    enable = true;

    extraOpts = {

      # Downloads komplett verbieten
      DownloadRestrictions = 3;

      # Datei-Auswahldialoge deaktivieren
      AllowFileSelectionDialogs = false;

      # Drucken deaktivieren
      PrintingEnabled = false;

      # Passwortmanager deaktivieren
      PasswordManagerEnabled = false;
      PasswordManagerAllowShowPasswords = false;

      # Autofill deaktivieren
      AutoFillEnabled = false;

      # Erweiterungen blockieren
      ExtensionInstallBlocklist = [
        "*"
      ];

      # Entwicklertools deaktivieren
      DeveloperToolsAvailability = 2;

      # Keine zusätzlichen Profile
      BrowserAddPersonEnabled = false;

      # Gastmodus deaktivieren
      BrowserGuestModeEnabled = false;

      # Nur Inkognito
      IncognitoModeAvailability = 2;

      # Google Cast / Streamen deaktivieren
      EnableMediaRouter = false;

      # Sharing Hub deaktivieren
      DesktopSharingHubEnabled = false;

      # Browser-Historie nicht speichern
      SavingBrowserHistoryDisabled = true;

      # Interne Verwaltungs-/Funktionsseiten blockieren
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
  # Pakete
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
  # Eigene Navigationsleiste
  # ------------------------------------------------------------

  environment.etc."kiosk/navigation/manifest.json".text = ''
    {
      "manifest_version": 3,
      "name": "Kiosk Navigation",
      "version": "1.0",
      "description": "Navigation für den öffentlichen Kiosk",
      "content_scripts": [
        {
          "matches": ["<all_urls>"],
          "js": ["navigation.js"],
          "run_at": "document_idle"
        }
      ]
    }
  '';

  environment.etc."kiosk/navigation/navigation.js" = {
    source = ./navigation.js;
    mode = "0644";
  };

  # ------------------------------------------------------------
  # Cage
  # ------------------------------------------------------------

  services.cage = {
    enable = true;

    user = "kiosk";

    # VT-Wechsel erlauben:
    # Ctrl+Alt+F2 / F3 / ...
    extraArguments = [
      "-s"
    ];

    program = "/etc/kiosk/start-browser.sh";
  };


  # ------------------------------------------------------------
  # Wartungs-TTY
  #
  # Wichtig:
  # Die Installations-ISO aktiviert normalerweise automatisch
  # den Benutzer "nixos" auf den virtuellen Konsolen.
  #
  # Das wird hier explizit abgeschaltet.
  # ------------------------------------------------------------

  services.getty.autologinUser = lib.mkForce null;

  systemd.services."getty@tty3".enable = true;
}