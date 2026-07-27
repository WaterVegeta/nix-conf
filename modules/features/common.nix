{self, inputs, ...}: {

    flake.nixosModules.common = {pkgs, lib, ...}:{

        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot.configurationLimit = 5;

#         services.displayManager.sddm.enable = true;

        services.greetd = {
            enable = true;
            settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        };


        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
	    localsend
	    micro
            ddcui
            ddcutil
            alacritty
            capitaine-cursors
            steam
            discord
            heroic
            fastfetch
            git
            xwayland-satellite
            brightnessctl
            vim
        ];

    };
}
