{ self, inputs, ...}: {
    flake.nixosModules.locales = {lib, pkgs, ...} :{
	
	time.timeZone = "Europe/Kyiv";

	i18n.defaultLocale = "en_US.UTF-8";
	i18n.supportedLocales = [
	    "en_US.UTF-8/UTF-8"
	    "uk_UA.UTF-8/UTF-8"
	];

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

    };
}
