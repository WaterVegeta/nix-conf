{ self, inputs, ... }: {
  flake.nixosModules.neovim = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
     
	#extraPackages = with pkgs; [
	#	kotlin-language-server
	#	ktlint
	#	ripgrep
	#	fd
	#];
 
      settings = {
        # This allows you to just type 'vim' or 'vi' in the terminal
        #aliases = [ "vi" "vim" ];
        
        # Once you have a custom lua configuration directory, uncomment this:
        # config_directory = ./nvim;
      };
      
      specs.dev-tools = {
        enable = true;
        
        # Inject the Kotlin LSP and standard fuzzy-finding tools directly into Neovim
        #runtimeDeps = with pkgs; [
        #  kotlin-language-server
        #  ktlint
        #  ripgrep
        #  fd
        #];
        
        # Pre-install foundational Nixpkgs plugins for auto-imports and completion
        data = with pkgs.vimPlugins; [
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
        ];

	pluginDeps = "startup";
	config = ''
            -- Map leader key to space
            vim.g.mapleader = " "
          
            -- Setup Kotlin LSP
            require('lspconfig').kotlin_language_server.setup{}
            
            -- Setup basic Telescope keybinds for finding files and text
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
          '';
      };
    };
  };
}
