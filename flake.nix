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

  outputs = { self, nixpkgs, ... }@inputs: {
    # User configuration
    hostname = "netsanet"; # Identify the system for networking tasks
    user = "ananth"; # Login username of primary user
    name = "Ananth Venkatesh"; # Full name of primary user

    # Used for git commits, among other things
    email = "dev.quantum9innovation@gmail.com";

    # Import hardware scan (device-specific)
    hardware = import ./hardware-configuration.nix;

    # Internationalization properties
    time.zone = "America/Los_Angeles";
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

    # Enforce defaults
    autoLogin = true;
    ssh = false;
    stateVersion = "24.05";
    kernel = nixpkgs.legacyPackages.x86_64-linux.linuxPackages_zen;
    audio.jack = false;
    proxy.enabled = false;
    hyprland = { };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-classic;
  };
}
