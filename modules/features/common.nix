{self, inputs, ...}: {

    flake.nixosModules.common = {pkgs, ...}:
    let 
	system = pkgs.stdenv.hostPlatform.system;
	old-xwayland-satellite = inputs.xwayland-satellite-old.legacyPackages.${system}.xwayland-satellite;

    in

    {

	imports = [
	    self.nixosModules.locales
	    self.nixosModules.add-script
	    self.nixosModules.ly-dm
	];

	nixpkgs.overlays = [
	    (self: super: {
		xwayland-satellite = old-xwayland-satellite;
	  })
	];

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot.configurationLimit = 5;

	environment.sessionVariables = {
	    GTK_THEME = "Adwaita-dark";
	    QT_QPA_PLATFORMTHEME = "qt6ct";
	};

	#programs.bash.enable = true;
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
	

	fonts.packages = with pkgs; [
	    noto-fonts
	    nerd-fonts.jetbrains-mono
	];
	
	services.logind.settings.Login.HandlePowerKey = "ignore";
	programs.dconf.enable = true;
	xdg.portal = {
	    enable = true;
	    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};
        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
	    bat
	    telegram-desktop
	    obs-studio
	    librewolf
	    dconf
	    localsend
            ddcui
            ddcutil
	    xwayland-satellite
            capitaine-cursors
            steam
            discord
            heroic
            fastfetch
            git
            brightnessctl
        ];

    };
}
