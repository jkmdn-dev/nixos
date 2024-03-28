(fn set-option [[name value & rest]]
  (assert (= (% (length rest) 2) 0))
  (let [{: nvim_set_option_value} vim.api]
    (assert (pcall nvim_set_option_value name value {})))
  (if (not= (length rest) 0) (set-option rest)))

(set-option [:termguicolors
             true
             :swapfile
             false
             :hlsearch
             false
             :number
             true
             :relativenumber
             true
             :mouse
             ""
             :clipboard
             :unnamedplus
             :breakindent
             true
             :undofile
             true
             :ignorecase
             true
             :smartcase
             true
             :signcolumn
             :yes
             :updatetime
             250
             :timeout
             true
             :timeoutlen
             300
             :completeopt
             "menuone,noselect"
             :expandtab
             true
             :shiftwidth
             2
             :tabstop
             2])

(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

