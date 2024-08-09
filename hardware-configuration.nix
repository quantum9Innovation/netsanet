# Do not modify this file! It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations. Please make changes
# to ./flake.nix and /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ff50e8ae-dd33-43c1-ac70-0ae13f18810e";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-8e9605ed-5561-4fcd-9186-b491ac100dcc".device =
    "/dev/disk/by-uuid/8e9605ed-5561-4fcd-9186-b491ac100dcc";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A84C-1AA5";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface.
  # In case of scripted networking (the default),
  # this is the recommended approach.
  # When using systemd-networkd it is still possible to use this option,
  # but it is recommended to use it in conjunction with explicit per-interface
  # declarations in `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  # networking.interfaces.enp45s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp46s0f0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
