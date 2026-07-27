{ self, inputs, ...}: {
    flake.nixosModules.myPcHardware = { config, lib, pkgs, modulesPath, ... }:
    let
#         mkMount = uuid: systemType: {
#                 device = "/dev/disk/by-uuid/${uuid}";
#                 fsType = "${systemType}";
#                 options = ["nofail"];
#         };
        mntFolder = "/home/what/mnt/";
        devicePath = "/dev/disk/by-uuid/";
    in {
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/disk/by-uuid/aae4108d-4b9d-4309-a9c8-27be785ab630";
        fsType = "ext4";
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/014E-41E5";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
        };

    fileSystems."${mntFolder}hdd" = {
        device = "${devicePath}d7a053a5-a977-4d36-bb32-b2a9be796215";
                fsType = "btrfs";
                options = ["nofail"];
    };

    fileSystems."${mntFolder}sdd1" = {
        device = "${devicePath}28fb161e-4972-4097-ae47-e5509780495a";
                fsType = "btrfs";
                options = ["nofail"];
    };

    fileSystems."${mntFolder}sdd2" = {
        device = "${devicePath}b177475d-71ac-436f-b665-10cb6c5d5550";
                fsType = "ext4";
                options = ["nofail"];
    };

#     fileSystems =
#         (mkMount "/home/what/mnt/hdd" "d7a053a5-a977-4d36-bb32-b2a9be796215" "btrfs")
#             // (mkMount "/home/what/mnt/sdd1" "28fb161e-4972-4097-ae47-e5509780495a" "btrfs")
#             // (mkMount "/home/what/mnt/sdd2" "b177475d-71ac-436f-b665-10cb6c5d5550" "ext4");
    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;




    hardware.i2c.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.bluetooth.settings = {
      General = {
        Experimental = true;
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;

      powerManagement.finegrained = false;

      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };


    };
}
