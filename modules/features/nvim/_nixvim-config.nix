{pkgs, ...}: {


      # Basic Settings
    opts = {
	number = true;
        relativenumber = true;
        shiftwidth = 4;
	cursorline = true;
    };


    globals.mapleader = " ";

    keymaps = [
	{
	    key = "<leader>cd";
	    mode = "n";
	    action = "<cmd>Ex<CR>";
	}

    ];
 
    colorschemes = {
	tokyonight={
	    enable = true;
	    #settings.transparent = true;
	    #settings.styles = {
	    #    sidebars = "transparent";
	    #    floats = "transparent";
	    #};
	};
    };
      # Enable plugins declaratively
    plugins = {
	lualine.enable = true;
        treesitter.enable = true;
        telescope = {
	    enable = true;
	    keymaps = {
		"<leader>ff" = "find_files";
		"<leader>fg" = "live_grep";
		"<leader>fb" = "buffers";
		"<leader>fh" = "help_tags";
	    };
	};
        # Example LSP setup
        lsp = {
          enable = true;
          servers = {
            nixd.enable = true; # Nix language server
          };
        };

    };
  

}
