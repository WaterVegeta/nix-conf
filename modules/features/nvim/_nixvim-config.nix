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
 
      # Enable plugins declaratively
    plugins = {
	lualine.enable = true;
        treesitter.enable = true;
        
        # Example LSP setup
        lsp = {
          enable = true;
          servers = {
            nixd.enable = true; # Nix language server
          };
        };

    };
  

}
