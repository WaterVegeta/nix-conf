{ self, inputs, ...}:{
    flake.nixosModules.add-script = {pkgs, ...}:{
	environment.systemPackages = [
	    (pkgs.writeShellApplication {
		name = "rebuild";

		runtimeInputs = [];

		text = ''
		    set -x
		    set -e

		    if [ -z "''${1:-}" ]; then
			echo "Error: Missing commit message."
			echo "Usage: my-updater <commit-message>"
			exit 1
		    fi
		    
		    pushd ~/nix-conf/


		    if git diff --quiet ; then
			echo "No changes detected, exiting."
			popd
			exit 0
		    fi

		    git diff -U0
		    
		    HOST="$1"
		    # Rebuild, output simplified errors, log trackebacks
		    sudo nixos-rebuild switch --flake .#"$HOST" 2>&1 | sudo tee nixos-switch.log || (grep --color error nixos-switch.log && exit 1)

		    echo "Success"
		    git add .
		    read -pr "Commit message: " commitName
		    echo "Committing with message: $commitName"
		    git commit -m "$commitName"
		    popd
		'';
	    })
	];
    };

}
