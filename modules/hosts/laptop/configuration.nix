# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ self, inputs, ...}:{

    flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
	modules = [
	    self.nixosModules.laptopConfig
	];
    };

    flake.nixosModules.laptopConfig = { config, pkgs, lib, ... }:
    {
	imports = [ # Include the results of the hardware scan.
	    inputs.nixvim.nixosModules.nixvim

	    self.nixosModules.laptopHardware
	    self.nixosModules.niri
	    self.nixosModules.common
	    self.nixosModules.nixvim

	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."luks-710f71b8-cdef-4fa2-aca7-0a075b11109a".device = "/dev/disk/by-uuid/710f71b8-cdef-4fa2-aca7-0a075b11109a";
	networking.hostName = "nixos"; # Define your hostname.


	networking.networkmanager.enable = true;
	networking.wireless = {
	    enable = true;
	};

	services.displayManager.ly.enable = true;

	networking.networkmanager.wifi.powersave = false;
	services.avahi = {
	    enable = true;
	    nssmdns4 = true;
	    openFirewall = true; # Automatically opens UDP 5353
	};

	networking.firewall = {
	    enable = true;
	    allowedTCPPorts = [ 5555 ]; # Default ADB connection port
		allowedTCPPortRanges = [ { from = 30000; to = 50000; } ]; # ADB pairing range
		allowedUDPPortRanges = [ { from = 30000; to = 50000; } ];
	};



	myNiri.extraSettings = {
	    outputs = {
		"eDP-1" = {
		    mode = "2560x1600@165.000";
		    scale = 1.4;
		    transform = "normal";
		    position = _: {props = { x = 0; y = 0; };};
		};
	    };

	}; 

	programs.bash.shellAliases = let
	    gpuPath = "/sys/bus/pci/devices/0000\:01\:00.0/power";
	in{
	    la = "ls -al";
	    cl = "clear";
	    test-build = "sudo nixos-rebuild test --flake ~/nix-conf#laptop";
	    switch-build = "sudo nixos-rebuild switch --flake ~/nix-conf#laptop";
	    gpu-status = "cat ${gpuPath}/runtime_status";
	    autosuspend-delay = "cat ${gpuPath}/autosuspend_delay_ms";
	    power-low = "sudo ryzenadj --stapm-limit=4000 --fast-limit=4000 --slow-limit=4000";

	};

	users.users."kenni" = {
	    isNormalUser = true;
	    description = "kenni";
	    extraGroups = [ "networkmanager" "wheel" ];
	};


	programs.firefox.enable = true;
	programs.steam.enable = true;
	nixpkgs.config.allowUnfree = true;

	services.power-profiles-daemon.enable = true;
	services.upower.enable = true;
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

	programs.starship = {
	    enable = true;
	    settings = {
		add_newline = true;
		command_timeout = 1300;
		scan_timeout = 50;
		format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
		character = {
		    success_symbol = "[](bold green) ";
		    error_symbol = "[✗](bold red) ";
		};
  };
	};
	#boot.kernelParams = [
	#    "pcie_aspm.policy=performance"
	#];

	services.hardware.openrgb.enable = true;

	environment.systemPackages = with pkgs; [
	    android-studio
	    openrgb
	    starship
	];

	system.stateVersion = "26.05"; # Did you read the comment?

    };
}
