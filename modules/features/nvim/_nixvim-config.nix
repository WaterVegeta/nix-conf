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
	{
	    mode = "n";
	    key = "<leader>r"; # Комбінація клавіш: Пробіл + r
	    action = ":w<CR>:split | terminal g++ -std=c++20 % -o %:r && ./%:r<CR>";
	    options = {
		silent = true;
		desc = "Compile and Run C++ file";
	    };
	}

    ];
 
    colorschemes = {
	tokyonight={
	    enable = true;
	    settings.transparent = true;
	    #settings.styles = {
	    #    sidebars = "transparent";
	    #    floats = "transparent";
	    #};
	};
    };

    extraPackages = with pkgs; [
	clang-tools
	cmake
    ];

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

		clangd = {
		    enable = true;
		};
		kotlin-language-server ={
		    enable = true;
	#		package = null;
		};
		nixd.enable = true; # Nix language server
	    };
	};

	cmp = {
	    enable = true;
	    autoEnableSources = true;
	    settings = {
		sources = [
		    { name = "nvim_lsp"; }
		    { name = "buffer"; }
		    { name = "path"; }
		];
		mapping = {
		    "<C-Space>" = "cmp.mapping.complete()";
		    "<CR>" = "cmp.mapping.confirm({ select = true })";
		    "<Tab>" = "cmp.mapping.select_next_item()";
		    "<S-Tab>" = "cmp.mapping.select_prev_item()";
		};
	    };
	};

    };
  

}
