{ self, inputs, ... }: {

  flake.nixosModules.myPcConfiguration = { config, pkgs, lib, ... }:
  let
    selfpkgs = self.packages."${pkgs.system}";
  in
  {
    # import any other modules from here
    imports = [
      self.nixosModules.myPcHardware
      self.nixosModules.niri
      self.nixosModules.common
    ];

    services.xserver.videoDrivers = ["nvidia"];

    networking.hostName = "what-host"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
    networking.networkmanager.enable = true;

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

		services.logind = {
			powerKey = "ignore";
		};

		environment.loginShellInit = ''
			if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
				exec niri
			fi
		'';
 		programs.bash.shellAliases ={
 		       	la = "ls -al";
 		       	cl = "clear";
 		       	test-build = "sudo nixos-rebuild test --flake ~/nix-conf#myPc";
 		       	switch-build = "sudo nixos-rebuild switch --flake ~/nix-conf#myPc";	
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

  # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

  # Enable CUPS to print documents.
    services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."what" = {
      isNormalUser = true;
      description = "what";
      extraGroups = [ "networkmanager" "wheel" "i2c"];
      packages = with pkgs; [
        kdePackages.kate
      ];
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      android-studio
    ];
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

    #END
    # ...
    };

}
