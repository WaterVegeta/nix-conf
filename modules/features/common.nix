{self, inputs, ...}: {

    flake.nixosModules.common = {pkgs, lib, ...}:{

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot.configurationLimit = 5;

	environment.loginShellInit = ''
	    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
		exec niri
		    fi
		    '';

	time.timeZone = "Europe/Kyiv";

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

	services.xserver.xkb = {
	    layout = "us";
	    variant = "";
	};

	services.logind.settings.Login.HandlePowerKey = "ignore";
	
#         services.displayManager.sddm.enable = true;

        #services.greetd = {
         #   enable = true;
          #  settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      #  };


        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
	    localsend
	    micro
            ddcui
            ddcutil
            alacritty
            capitaine-cursors
            steam
            discord
            heroic
            fastfetch
            git
            xwayland-satellite
            brightnessctl
            vim
	#	neovim
        ];

    };
}
