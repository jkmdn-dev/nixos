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

;; making sure <space> remain noop in v mode
(let [{: nvim_set_keymap} (. vim :api)]
  (nvim_set_keymap :v :<Space> :<Nop> {:noremap true :silent true}))

;; folding settings
(let [options (. vim :o)]
  (tset options :foldcolumn :1)
  (tset options :foldlevel 99)
  (tset options :foldlevelstart 99)
  (tset options :foldenable true))

;; map ambigous W and Q to w and qemu

(let [{: nvim_create_user_command} (. vim :api)]
  (nvim_create_user_command :W :w {:bang true})
  (nvim_create_user_command :Wa :wa {:bang true})
  (nvim_create_user_command :Wqa :wqa {:bang true})
  (nvim_create_user_command :Waq :wqa {:bang true})
  (nvim_create_user_command :WA :wa {:bang true})
  (nvim_create_user_command :WQa :wqa {:bang true})
  (nvim_create_user_command :WAq :wqa {:bang true})
  (nvim_create_user_command :WQA :wqa {:bang true})
  (nvim_create_user_command :WAQ :wqa {:bang true})
  (nvim_create_user_command :Q :q {:bang true})
  (nvim_create_user_command :Qa :qa {:bang true})
  (nvim_create_user_command :QA :qa {:bang true}))

