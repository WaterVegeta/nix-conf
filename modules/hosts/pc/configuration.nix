{ self, inputs, ... }: {

    flake.nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem{
	modules = [
	    self.nixosModules.myPcConfiguration
	];
    };
    
 
    flake.nixosModules.myPcConfiguration = { config, pkgs, lib, ... }:
    {
    # import any other modules from here
	imports = [
	    self.nixosModules.myPcHardware
	    self.nixosModules.niri
	    self.nixosModules.nixvim
	    self.nixosModules.common
	];

	services.xserver.videoDrivers = ["nvidia"];

	networking.hostName = "what-host"; # Define your hostname.

	networking.networkmanager.enable = true;
	programs.bash.shellAliases ={
	    la = "ls -al";
	    cl = "clear";
	    test-build = "sudo nixos-rebuild test --flake ~/nix-conf#pc";
	    switch-build = "sudo nixos-rebuild switch --flake ~/nix-conf#pc";	
	};


	myNiri.extraSettings = {
	    outputs = {
		"DP-1" = {
		    mode = "1920x1080@165.004";
		    scale = 1;
		    transform = "normal";
		    position = _: {props = {x = 0; y = 0;};};
		};
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
