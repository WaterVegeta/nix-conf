{self, inputs, ...}:{

    flake.nixosModules.myAlacritty = { pkgs, ... }:

    let

	transparentAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
	    inherit pkgs;
# Configure via the built-in module options
	    settings = {
		window.opacity = 0.85;
	    };
	};
# Create the alacritty.toml config file inside the Nix store
    in
    {
# Add the wrapped package to your system packages
	environment.systemPackages = [
	    transparentAlacritty
	];

# Reminder: A compositor is still required for transparency to render
    };
}
