{

  #  /*****                                                 /******   /****
  #  |*    |  |*   |    **     ****     **    *****        |*    |  /*    *
  #  |*    |  |*   |   /* *   /*       /* *   |*   |      |*    |  |*
  #  |*    |  |*   |  /*   *   ****   /*   *  |*   /     |*    |   ******
  #  |*  * |  |*   |  ******       |  ******  *****     |*    |         |
  #  |*   *   |*   |  |*   |   *   |  |*   |  |*  *    |*    |   *     |
  #   **** *   ****   |*   |    ****  |*   |  |*   *   ******    *****
  #
  #  ==========================================================================

  # This is my personal Quasar configuration flake.
  # It is passed into the QuasarOS configuration flake to build my system.
  # You should include a specific version of this flake as an input
  # in your system configuration flake and pipe its output to the `make`
  # function to build your system.
  description = "Quasar configuration flake for Netsanet";

  inputs = {
    # QuasarOS uses the nixpkgs unstable channel,
    # so new package updates are always immediately available.
    # Many user packages are also built directly
    # from the latest stable git source,
    # usually the last commit on the `main` branch.
    # This is the recommended way to install user packages
    # which are not critical for system functionality on QuasarOS.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    rec {
      # User configuration
      hostname = "netsanet"; # Identify the system for networking tasks
      user = "ananth"; # Login username of primary user
      name = "Ananth"; # Full name of primary user

      # Git configuration
      git = {
        name = "Ananth Venkatesh";
        email = "dev.quantum9innovation@gmail.com";
      };

      # Meta configuration
      flake = "/home/${user}/gh/q9i/nixos";

      # Import hardware scan (device-specific)
      hardware = import ./hardware-configuration.nix;
      hyprland.monitors = [
        "DP-1,2560x1440@165,1920x0,auto"
        "HDMI-A-1,1920x1080@60,0x0,1"
      ];

      # Internationalization properties
      locale = "es_US.UTF-8";

      # Power-efficient NVIDIA GPU settings
      graphics = {
        opengl = true;
        nvidia = {
          enabled = true;
          intelBusId = "PCI:00:02:0";
          nvidiaBusId = "PCI:01:00:0";
        };
      };

      # System overrides
      overrides = [ ];
      homeOverrides = [ ];

      # Custom packages
      systemPackages = pkgs: with pkgs; [ hello ];
      homePackages =
        pkgs: with pkgs; [
          hello-wayland
          spotube
          proselint
          nodePackages.cspell
        ];

      # Enforce defaults
      system = "x86_64-linux";
      kernel = "zen";
      secureboot.enabled = true;
      stateVersion = "24.05";
      autoLogin = true;
      ssh.enabled = false;
      hyprland.mod = "SUPER";
      audio.jack = false;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
