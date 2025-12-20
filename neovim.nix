{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # --- 1. THEME: Catppuccin MOCHA (The deep, gorgeous one) ---
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # The darkest and most vibrant
        transparent_background = false; 
        term_colors = true;
        integrations = {
          cmp = true;
          noice = true;
          notify = true;
          neotree = true;
          harpoon = true;
          gitsigns = true;
          treesitter = true;
          telescope.enabled = true;
          lualine = true;
        };
      };
    };

    # --- 2. GLOBAL OPTIONS ---
    opts = {
      number = true;         
      relativenumber = true; 
      shiftwidth = 2;        
      tabstop = 2;
      smartindent = true;
      cursorline = true;
      termguicolors = true;
      undofile = true;       
    };

    # --- 3. KEYMAPS ---
    keymaps = [
      {
        mode = "n";
        key = "<C-t>";
        action = "<cmd>Telescope find_files<CR>";
      }
    ];

    # --- 4. PLUGINS ---
    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;     
      oil.enable = true;          
      lastplace.enable = true;    

      # TREESITTER: This is what makes the colors "Gorgeous"
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings.highlight.enable = true;
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      # RUST: The full suite
      rustaceanvim = {
        enable = true;
      };

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix
          lua_ls.enable = true; # Lua
        };
      };

      # AUTOCOMPLETE (Fixed with Arrow Keys!)
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            # --- ARROW KEY SUPPORT ---
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
    };

    # Extra packages to make sure EVERYTHING works
    extraPackages = with pkgs; [
      ripgrep
      rust-analyzer # Explicitly add the brains for Rust
      bacon         # Fast rust background checker
    ];
  };
}
