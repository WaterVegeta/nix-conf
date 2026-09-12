{
    inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

	flake-parts.url = "github:hercules-ci/flake-parts";
	import-tree.url = "github:vic/import-tree";

# by old means 0.8.0 version cuz on 0.8.2 steam menus doesnt work
	xwayland-satellite-old.url = "github:nixos/nixpkgs/cb73bff643b27b72994ddda0f98cb1cc6ed58c9c";
	wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
	nixvim = {
	    url = "github:nix-community/nixvim";
#inputs.nixpkgs.follows = "nixpkgs";
	};
	dms = {
	    url = "github:AvengeMedia/DankMaterialShell";
	};

	home-manager = {
	    url = "github:nix-community/home-manager/release-26.05";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
	dms-plugin-registry = {
	    url = "github:AvengeMedia/dms-plugin-registry";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
