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
	    #self.nixosModules.niri
	    self.nixosModules.common
	    self.nixosModules.nixvim
	    self.nixosModules.myAlacritty
	    inputs.home-manager.nixosModules.home-manager
	];
	home-manager = {
	    useGlobalPkgs = true;
	    useUserPackages = true;
	    backupFileExtension = "backup"; 
	    extraSpecialArgs = { inherit inputs; };
	    users.what = {
		imports = [
		    ./../../features/desktop/niri/_niri-home.nix
		    ./../../features/desktop/dms/_dms-home.nix
		];
		home.username = "what";
		home.homeDirectory = "/home/what";
		home.stateVersion = "26.05";

		wm.niri.display = ''
		    output "eDP-1"{
			mode "2560x1600@165.000"
			scale 1.4
			transform "normal"
			position x=0 y=0
		    }
		'';
	    };
	};


	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."luks-710f71b8-cdef-4fa2-aca7-0a075b11109a".device = "/dev/disk/by-uuid/710f71b8-cdef-4fa2-aca7-0a075b11109a";
	networking.hostName = "laptop"; # Define your hostname.


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

	programs.bash= {
	    enable = true;
	    shellAliases = let
		gpuPath = "/sys/bus/pci/devices/0000\:01\:00.0/power";
	    in{
		la = "ls -al";
		cl = "clear";
		nrt = "sudo nixos-rebuild test --flake ~/nix-conf#laptop";
		nrs = "sudo nixos-rebuild switch --flake ~/nix-conf#laptop";
		gactive = "cat ${gpuPath}/runtime_status";
		autosuspend-delay = "cat ${gpuPath}/autosuspend_delay_ms";
		lpower = "sudo ryzenadj --stapm-limit=4000 --fast-limit=4000 --slow-limit=4000";
	    };
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

	services.hardware.openrgb.enable = true;

	environment.systemPackages = with pkgs; [
	    android-studio
	    openrgb
	    starship
	];

	system.stateVersion = "26.05"; # Did you read the comment?

    };
}
