{ self, inputs, ... }: {

    flake.nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem{
	specialArgs = { inherit inputs;};
	modules = [
	    self.nixosModules.myPcConfiguration
	];
    };
    
 
    flake.nixosModules.myPcConfiguration = { config, pkgs, lib, ... }:
    {
	imports = [
	    self.nixosModules.myPcHardware
	    #self.nixosModules.niri
	    self.nixosModules.nixvim
	    self.nixosModules.common
	    self.nixosModules.myAlacritty
	    #self.nixosModules.dms-niri
	    inputs.home-manager.nixosModules.home-manager
	];

	programs.niri.enable = true;
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
		home.pointerCursor = {
		    gtk.enable = true;
		    package = pkgs.capitaine-cursors;
		    name = "capitaine-cursors";
		    size = 36; # Set your desired cursor size here
		};
		home.stateVersion = "26.05";

		wm.niri.display = ''
		    output "DP-1"{
			mode "1920x1080@165.004"
			scale 1
			transform "normal"
			position x=0 y=0
		    }
		'';
	    };
	};

	services.xserver.videoDrivers = ["nvidia"];

	networking.hostName = "what-host"; # Define your hostname.

	networking.networkmanager.enable = true;
	programs.bash ={
	    enable =true;
	    shellAliases ={
		la = "ls -al";
		cl = "clear";
		nrt = "sudo nixos-rebuild test --flake ~/nix-conf#pc";
		nrs = "sudo nixos-rebuild switch --flake ~/nix-conf#pc";	
	    };
	};

	programs.appimage.enable = true;
	programs.appimage.binfmt = true;

	xdg.portal = {
	    enable = true;
	    extraPortals = [ 
		pkgs.xdg-desktop-portal-gnome # Needed for Niri's full-screen capture
		pkgs.xdg-desktop-portal-gtk   # Fallback for UI dialogs
	    ];
	    config = {
		niri = {
		    default = [ "gnome" "gtk" ];
		    "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
		    "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
		};
	    };
	};
	services.printing.enable = true;

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
	    enable = true;
	    alsa.enable = true;
	    alsa.support32Bit = true;
	    pulse.enable = true;
	    wireplumber = {
		enable = true;
		extraConfig."bluetooth" = {
		    "monitor.bluez.properties" = {
			"bluez5.codecs" = [ "sbc" "sbc_xq" "aac" "aptx" "aptx_hd" ];
		    };
		};
	    };
	};

	users.users."what" = {
	    isNormalUser = true;
	    description = "what";
	    extraGroups = [ "networkmanager" "wheel" "i2c"];
	};

	programs.firefox.enable = true;

	environment.systemPackages = with pkgs; [
	    android-studio
	];
	system.stateVersion = "26.05"; # Did you read the comment?

    };

}
