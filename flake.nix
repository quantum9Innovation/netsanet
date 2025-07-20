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

    # Enable pre-commit hooks on this repository
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-merge-conflicts.enable = true;
            commitizen.enable = true;
            convco.enable = true;
            forbid-new-submodules.enable = true;
            gitlint.enable = true;
            markdownlint.enable = true;
            mdformat.enable = true;
            mdsh.enable = true;
            deadnix.enable = true;
            flake-checker.enable = true;
            nil.enable = true;
            statix.enable = true;
            nixfmt-rfc-style.enable = true;
            ripsecrets.enable = true;
            trufflehog.enable = false;
            shellcheck.enable = true;
            shfmt.enable = true;
            typos.enable = true;
            check-yaml.enable = true;
            yamlfmt.enable = true;
            yamllint.enable = true;
            yamllint.settings.preset = "relaxed";
            actionlint.enable = true;
            check-added-large-files.enable = true;
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            check-symlinks.enable = true;
            detect-private-keys.enable = true;
            end-of-file-fixer.enable = true;
            mixed-line-endings.enable = true;
            tagref.enable = true;
            trim-trailing-whitespace.enable = true;
            check-toml.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });

      # User configuration
      hostname = "netsanet"; # Identify the system for networking tasks
      user = "ananth"; # Login username of primary user
      name = "Ananth"; # Full name of primary user

      # Git configuration
      git = {
        name = "Ananth Venkatesh";
        email = "dev.quantum9innovation@gmail.com";
        signing = {
          enabled = true;
          key = "~/.ssh/id_ed25519.pub";
        };
      };

      # Meta configuration
      flake = "/home/${user}/gh/q9i/nixos";
      secureboot.enabled = false;

      # Import hardware scan (device-specific)
      hardware = import ./hardware-configuration.nix;
      hyprland.monitors = [
        "eDP-1,2560x1600@60,1920x0,auto"
        "HDMI-A-1,preferred,auto,auto"
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
      homePackages = pkgs: with pkgs; [ hello-wayland ];

      formatter = forAllSystems (_system: nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style);
    };
}
