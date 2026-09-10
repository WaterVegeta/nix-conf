{ self, ...}: {
    flake.nixosModules.ly-dm = {pkgs, ...}: {
	services.displayManager.ly ={
	    enable = true;	
	    settings = { 
		load = true; 
		save = false;
		animation = 1;
		animate = true;
	#clock = "%c";
		bigclock = true;

	    };
	};
    };

}
