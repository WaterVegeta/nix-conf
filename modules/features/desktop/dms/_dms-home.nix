{ inputs, ...}: {
    imports = [
	inputs.dms.homeModules.dank-material-shell
    ];
    
    programs.dank-material-shell = {
	enable = true;
	enableSystemMonitoring = true;
	systemd.enable = true;
    };

}
