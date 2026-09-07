{ self, input, ...}:{
    
    flake.nixosModules.dms = { pkgs, ...} : {

	programs.dms-shell = {
	    enable = true;

	    systemd = {	
		enable = true;             # Systemd service for auto-start
		restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
	    };

# Core features
	    enableSystemMonitoring = false;     # System monitoring widgets (dgop)
	    enableVPN = false;                  # VPN management widget
	    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
	    enableAudioWavelength = false;      # Audio visualizer (cava)
	    enableCalendarEvents = true;       # Calendar integration (khal)
	};

    };

}
