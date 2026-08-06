# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ self, inputs, ...}:{

	flake.nixosModules.laptopConfig = { config, pkgs, lib, ... }:
	{
		imports = [ # Include the results of the hardware scan.
				self.nixosModules.laptopHardware
				self.nixosModules.niri
				self.nixosModules.common
    		];

		  # Bootloader.
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;
		
		boot.initrd.luks.devices."luks-710f71b8-cdef-4fa2-aca7-0a075b11109a".device = "/dev/disk/by-uuid/710f71b8-cdef-4fa2-aca7-0a075b11109a";
		networking.hostName = "nixos"; # Define your hostname.
 			 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

 			 # Configure network proxy if necessary
 			 # networking.proxy.default = "http://user:password@proxy:port/";
 			 # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

 			 # Enable networking
  		networking.networkmanager.enable = true;
 		networking.wireless = {
 			enable = true;
 		};
		
		#services.greetd = {
      		#	enable = true;
      		#	settings = {
       		#		 default_session = {
         				 # Launches tuigreet, shows the clock, remembers your last user, and runs Niri upon login
          	#			command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri";
          	#			user = "kenni";
        	#		};
      		#	};
    		#};

		environment.loginShellInit = ''
			if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
				exec niri
			fi
		'';

 		# Set your time zone.
 		time.timeZone = "Europe/Kyiv";

 		# Select internationalisation properties.
 		i18n.defaultLocale = "en_US.UTF-8";

 		i18n.extraLocaleSettings = {
 			LC_ADDRESS = "uk_UA.UTF-8";
 		  	LC_IDENTIFICATION = "uk_UA.UTF-8";
 		   	LC_MEASUREMENT = "uk_UA.UTF-8";
 		   	LC_MONETARY = "uk_UA.UTF-8";
 		   	LC_NAME = "uk_UA.UTF-8";
 		  	LC_NUMERIC = "uk_UA.UTF-8";
 		   	LC_PAPER = "uk_UA.UTF-8";
 		   	LC_TELEPHONE = "uk_UA.UTF-8";
 		   	LC_TIME = "uk_UA.UTF-8";
 		 };

 		 # Configure keymap in X11
 		services.xserver.xkb = {
			layout = "us";
 		   	variant = "";
 		};
 		
		services.logind = {
			powerKey = "ignore";
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

 		programs.bash.shellAliases ={
 		       	la = "ls -al";
 		       	cl = "clear";
 		       	test-build = "sudo nixos-rebuild test --flake ~/nix-conf#myLaptop";
 		       	switch-build = "sudo nixos-rebuild switch --flake ~/nix-conf#myLaptop";
 		       	gpu-status = "cat /sys/bus/pci/devices/0000\:01\:00.0/power/runtime_status";
 		       	power-low = "sudo ryzenadj --stapm-limit=4000 --fast-limit=4000 --slow-limit=4000";
 		       
		};
 		 
 		 # Define a user account. Don't forget to set a password with ‘passwd’.
 		users.users."kenni" = {
 		   	isNormalUser = true;
 		   	description = "kenni";
 		   	extraGroups = [ "networkmanager" "wheel" ];
 		   	packages = with pkgs; [];
 		};

 		networking.firewall.allowedTCPPorts = [ 53317 ];
 		networking.firewall.allowedUDPPorts = [ 53317 ];

 		programs.firefox.enable = true;
 		programs.steam.enable = true;
 		 # Allow unfree packages
 		nixpkgs.config.allowUnfree = true;

 		services.power-profiles-daemon.enable = true;
 		services.upower.enable = true;
 		hardware.bluetooth.enable = true;

  		# List packages installed in system profile. To search, run:
  		# $ nix search wget
  		environment.systemPackages = with pkgs; [
  		      android-studio
  		      vim
  		      git
  		#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  		#  wget
  		];

  		# Some programs need SUID wrappers, can be configured further or are
  		# started in user sessions.
  		# programs.mtr.enable = true;
  		# programs.gnupg.agent = {
  		#   enable = true;
  		#   enableSSHSupport = true;
  		# };

  		# List services that you want to enable:

  		# Enable the OpenSSH daemon.
  		# services.openssh.enable = true;

  		# Open ports in the firewall.
  		# networking.firewall.allowedTCPPorts = [ ... ];
  		# networking.firewall.allowedUDPPorts = [ ... ];
  		# Or disable the firewall altogether.
  		# networking.firewall.enable = false;

  		# This value determines the NixOS release from which the default
  		# settings for stateful data, like file locations and database versions
  		# on your system were taken. It‘s perfectly fine and recommended to leave
  		# this value at the release version of the first install of this system.
  		# Before changing this value read the documentation for this option
  		# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  		system.stateVersion = "26.05"; # Did you read the comment?

	};
}
