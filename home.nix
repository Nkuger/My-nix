{ config, pkgs, inputs, ... }:

{
  # Import nixvim home-manager module
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  
  # Home Manager Settings
  home.username = "nkuger";
  home.homeDirectory = "/home/nkuger";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  
  # System Packages
  home.packages = with pkgs; [
    # Language Servers
    nil
    nodePackages.typescript-language-server
    python313Packages.python-lsp-server
    python313Packages.debugpy
    
    # Development Tools
    lldb
    ripgrep
    fd
    
    # Formatters
    prettier
    python313Packages.black
    python313Packages.isort
    nixpkgs-fmt
    

  ];
  
  # Git Configuration
  programs.git = {
    enable = true;
    settings = {
    user = { 
      name = "nkuger";
      email = "nkuger.has@proton.me";
   };
  };
 }; 

  # Fish Shell
  programs.fish = {
    enable = true;
    interactiveShellInit = "set -g fish_greeting";
  };
  
  # Bash Configuration (auto-launches fish)
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
    shellAliases = {
      hm-update = "home-manager switch";
    };
  };
  
  # Neovim Configuration with nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Leader key
    globals.mapleader = " ";
    
    # Vim Options
    opts = {
      # Line Numbers
      number = true;
      relativenumber = true;
      
      # Mouse Support
      mouse = "a";
      
      # Indentation
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;
      autoindent = true;
      
      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      
      # UI
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      scrolloff = 8;
      wrap = false;
      
      # Performance
      updatetime = 300;
      timeoutlen = 400;
      
      # Splits
      splitbelow = true;
      splitright = true;
    };
    
    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        term_colors = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          telescope = true;
          lsp_trouble = true;
        };
      };
    };
    
    # Extra Packages Available to Neovim
    extraPackages = with pkgs; [
      ripgrep
      fd
      lldb
      nixpkgs-fmt
      prettier
      black
      isort
    ];
    
    # Plugins
    plugins = {
      # Icons
      web-devicons.enable = true;
      
      # Autocompletion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
      
      # Snippet Engine
      luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      
      # Syntax Highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          incremental_selection.enable = true;
        };
      };
      
      # Fuzzy Finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "node_modules"
              "__pycache__"
            ];
          };
        };
      };
      
      # File Explorer
      nvim-tree = {
        enable = true;
        settings = {
          disable_netrw = true;
          hijack_cursor = true;
          sync_root_with_cwd = true;
          view = {
            width = 30;
            side = "left";
          };
          renderer = {
            group_empty = true;
            icons = {
              show = {
                file = true;
                folder = true;
                folder_arrow = true;
                git = true;
              };
            };
          };
        };
      };
      
      # Status Line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            globalstatus = true;
          };
        };
      };
      
      # Git Integration
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked = { text = "┆"; };
          };
        };
      };
      
      # Auto Pairs
      nvim-autopairs.enable = true;
      
      # Comment Toggle
      comment.enable = true;
      
      # Indent Guides
      indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
          indent.char = "│";
        };
      };
      
      # Diagnostics Panel
      trouble.enable = true;
      
      # Which Key (shows keybindings)
      which-key.enable = true;
      
      # Debugger (fixed structure)
      dap.enable = true;
      dap-ui.enable = true;
      dap-python.enable = true;
      
      # LSP Configuration
      lsp = {
        enable = true;
        servers = {
          # Nix
          nil_ls.enable = true;
          
          # Python
          pyright = {
            enable = true;
            settings = {
              python = {
                pythonPath = "${pkgs.python313}/bin/python";
                analysis = {
                  typeCheckingMode = "basic";
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                };
              };
            };
          };
          
          # TypeScript/JavaScript
          ts_ls.enable = true;
          
          # Bash
          bashls.enable = true;
        };
      };
      
      # Formatting
      lsp-format.enable = true;
    };
    
    # Keymaps
    keymaps = [
      # File Explorer
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "Toggle file explorer";
      }
      
      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help tags";
      }
      
      # Buffer Navigation
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Delete buffer";
      }
      
      # Window Navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Go to left window";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Go to lower window";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Go to upper window";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Go to right window";
      }
      
      # Window Resize
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }
      
      # Clear Search Highlighting
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlighting";
      }
      
      # LSP
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
        options.desc = "Go to declaration";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<cr>";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
        options.desc = "Show diagnostics";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        options.desc = "Next diagnostic";
      }
      
      # Trouble
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics";
      }
      
      # Git
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<cr>";
        options.desc = "Git blame line";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options.desc = "Preview hunk";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        options.desc = "Reset hunk";
      }
      
      # Save and Quit
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Quit";
      }
    ];
    
    # Auto Commands
    autoCmd = [
      {
        event = ["BufWritePre"];
        pattern = ["*.py"];
        command = "lua vim.lsp.buf.format()";
      }
    ];
  };
}
