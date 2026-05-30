{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  console.keyMap = "pt-latin9";

  services.xserver.enable = false;
  services.xserver.xkb.layout = "pt";

  hardware.graphics = {
    enable = true;
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  users.users.rui = {
    isNormalUser = true;
    description = "Rui Lourenço";
    extraGroups = [
      "gamemode"
      "nerworkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "rui";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ngc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };

    histSize = 10000;

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git"];
    };
  };

  programs.foot = {
    enable = true;
    theme = "tokyonight-night";
    settings = {
      main = {
        font = "monospace:size=12";
        initial-window-size-pixels="960x640";
      };
      scrollback = {
        lines=100000;
      };
    };
  };

  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Rui Lourenço";
        email = "ruinzinho_1991@hotmail.com";
      };
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
      pkief.material-icon-theme
    ];
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "--rt"
      "--expose-wayland"
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = false;
  };

  environment.systemPackages = with pkgs; [
    brave
    discord
    lutris
    mangohud
    qbittorrent
    unrar
    unzip
    vim
    vlc
    winetricks
    wineWow64Packages.staging
    wget
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";

}
