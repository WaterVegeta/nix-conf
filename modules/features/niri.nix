{ self, inputs, ...}: {

    flake.nixosModules.niri = {pkgs, lib, config, ...}: 
	let
	    mkMenu = menu: let
		configFile = pkgs.writeText "config.yaml"
		(lib.generators.toYAML {} {
		    anchor = "bottom-right";
# ...
		    inherit menu;
		});
	    in
	    pkgs.writeShellScriptBin "my-menu" ''
		exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
	    '';
	    noctaliaPkg = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
	    noctalia = lib.getExe noctaliaPkg;
	    commonSettings = {
		spawn-at-startup = [
		    noctalia
		];

		cursor = {
		    xcursor-theme = "capitaine-cursors";
		    xcursor-size = 36;
		};

		prefer-no-csd = true;
		xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

		input ={
		    disable-power-key-handling = _:{};
		    keyboard = {
			xkb = {
			    layout = "us,ua";
			    options = "grp:alt_shift_toggle,caps:escape";
			};
			repeat-rate = 30;
			repeat-delay = 250;
			#numlock = {};
		    };

		    mouse = {
			accel-profile = "flat";
		    };

		    focus-follows-mouse = _: {
			max-scroll-amount = "0%";
		    };
		    touchpad = {
			tap = _: {};
			natural-scroll = _: {};
			dwt = _:{};
#accel-speed = 0.5;
#accel-profile = "flat";
#scroll-method = "two-finger";
		    };
		};

		layout = {
		    always-center-single-column = _: {};
		    gaps = 8;
		    background-color = "transparent";
		    preset-column-widths = [
		    {proportion = 0.33333;}
		    {proportion = 0.5;}
		    {proportion = 0.8;}
		    ];
		    focus-ring = {
			width = 3;
			active-color = "#f46581";
		    };
		};

		animations = {
		    slowdown = 1;
		    window-open = let
			shader = ./niri-shader.frag;
		    in{
			duration-ms = 250;
			curve = "linear";
			
			custom-shader = "${shader}";
		    };
		};

		layer-rules = [
		    {
			matches = [ {} ];
			place-within-backdrop = true;
		    }
		];

		window-rules = [
#{
#	matches = [
#      		{ app-id = "firefox$";}
#      		{ title = "^Picture-in-Picture$";}
#  	];
#  	open-floating = true;
#}

		{
		    geometry-corner-radius = 12;
		    clip-to-geometry = true;
		}
		];

		binds = {
		    "Mod+Return".spawn = "alacritty";                  
		    "Mod+D" = _: {

			props.repeat = false;
			content.spawn-sh = pkgs.lib.getExe (mkMenu [
			    {
				key = "f";
				desc = "Firefoxi";
				cmd = "firefox";
			    }
			    {
				key = "s";
				desc = "LocalSend";
				cmd = "localsend_app";
			    }
			    {
				key = "A";
				desc = "Android Studio";
				cmd = "android-studio";
			    }
			    {
				key = "q";
				desc = "exit";
				cmd = "null";
			    }
			]);
		    };
		    "Mod+S".spawn-sh = "${noctalia} ipc call launcher toggle";
# --- Window management ---
		    "Mod+Q".close-window = {};
		    "Mod+Shift+F".fullscreen-window = {};
		    "Mod+V".toggle-window-floating = {};
		    "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
		    "Mod+Shift+E".quit = {};                # asks for confirmation by default
			"Mod+C".center-column = {};
		    "Mod+Shift+C".center-visible-columns = {};
		    "Mod+A".spawn-sh = "${noctalia} ipc call launcher clipboard";

		    "XF86AudioRaiseVolume".spawn-sh = "${noctalia} ipc call volume increase";
		    "XF86AudioLowerVolume".spawn-sh = "${noctalia} ipc call volume decrease";

		    "XF86AudioMute".spawn-sh = "${noctalia} ipc call volume muteOutput";

		    "XF86AudioMicMute".spawn-sh = "";

		    "XF86AudioPlay".spawn-sh = "platerctl play-pause";
		    "XF86AudioStop".spawn-sh = "playerctl play-pause";

		    "XF86AudioPrev".spawn-sh = "playerctl previous";
		    "XF86AudioNext".spawn-sh = "platerctl next";

		    "XF86MonBrightnessUp".spawn-sh = "brightnessctl set +5%";
		    "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5-%";

		    "Mod+P".spawn-sh = "${noctalia} ipc call wallpaper toggle";

# --- Column management ---
		    "Mod+Comma".consume-window-into-column = {};   # pull the focused window into the adjacent column (stack it)
		    "Mod+Period".expel-window-from-column = {};    # pop the focused window out into its own new column

# --- Resize column to fill screen width ---
		    "Mod+F".maximize-column = {};

# --- Focus movement ---
		    "Mod+Left".focus-column-left = {};
		    "Mod+Right".focus-column-right = {};
		    "Mod+Up".focus-window-up = {};
		    "Mod+Down".focus-window-down = {};

# --- Moving windows/columns ---
		    "Mod+Shift+Left".move-column-left = {};
		    "Mod+Shift+Right".move-column-right = {};
		    "Mod+Shift+Up".move-window-up = {};
		    "Mod+Shift+Down".move-window-down = {};

# --- Workspaces ---
		    "Mod+Page_Down".focus-workspace-down = {};
		    "Mod+Page_Up".focus-workspace-up = {};
		    "Mod+Shift+Page_Down".move-column-to-workspace-down = {};
		    "Mod+Shift+Page_Up".move-column-to-workspace-up = {};

# --- Sizing ---
		    "Mod+R".switch-preset-column-width = {};
		    "Mod+Shift+R".reset-window-height = {};
		    "XF86PowerOff".spawn-sh = "${noctalia} ipc call sessionMenu toggle";
# --- Misc ---
		    "Print".screenshot = {};
		};
    };
    in {
	options.myNiri.extraSettings = lib.mkOption {
	    type = lib.types.attrs;
	    default = {};
	    description = "per host settings";
	};
	config = {
	    programs.niri = {
		enable = true;
		package = inputs.wrapper-modules.wrappers.niri.wrap {
		    inherit pkgs;
		    settings = lib.recursiveUpdate commonSettings config.myNiri.extraSettings;
		};
	    };

	    environment.variables = {
		XCURSOR_THEME = "capitaine-cursors";
		XCURSOR_SIZE = "36";
	    };

	};
    };
}
