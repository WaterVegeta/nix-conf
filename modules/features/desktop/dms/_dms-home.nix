{ inputs, ...}: {
    imports = [
	inputs.dms.homeModules.dank-material-shell
	inputs.dms-plugin-registry.nixosModules.default
    ];
    
    programs.dank-material-shell = {
	enable = true;
	enableSystemMonitoring = true;
	systemd.enable = true;

	plugins = {
	    catWidget.enable = true;
	};
    };

}
