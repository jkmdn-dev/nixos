(require :general-settings)

(local hotpot [:rktjmp/hotpot.nvim])

(local oil {1 :stevearc/oil.nvim
            :opts {}
            :dependencies [:nvim-tree/nvim-web-devicons]})

(local treesitter
       {1 :nvim-treesitter/nvim-treesitter
        :build ":TSUpdate"
        :config (fn []
                  (let [{: setup} (require :nvim-treesitter.configs)]
                    (setup {:ensure_installed :all
                            :sync_install false
                            :highlight {:enable true}
                            :indent {:enable true}
                            :incremental_selection {:enable true
                                                    :keymaps {:init_selection :<c-space>
                                                              :node_incremental :<c-space>
                                                              :node_decremental :<M-space>}}
                            :textobjects {:select {:enable true
                                                   :lookahead true
                                                   :keymaps {:aa "@parameter.outer"
                                                             :ia "@parameter.inner"
                                                             :af "@function.outer"
                                                             :if "@function.inner"
                                                             :ac "@class.outer"
                                                             :ic "@class.inner"}}
                                          :move {:enable true
                                                 :set_jumps true
                                                 :goto_next_start {"]m" "@function.outer"
                                                                   "]]" "@class.outer"}
                                                 :goto_next_end {"]M" "@function.outer"
                                                                 "][" "@class.outer"}
                                                 :goto_previous_start {"[m" "@function.outer"
                                                                       "[[" "@class.outer"}
                                                 :goto_previous_end {"[M" "@function.outer"
                                                                     "[]" "@class.outer"}}
                                          :swap {:enable true
                                                 :swap_next {"<c-,>" "@parameter.inner"}
                                                 :swap_previous {"<M-,>" "@parameter.inner"}}}})))})

(local guard {1 :nvimdev/guard.nvim :dependencies [:nvimdev/guard-collection]})

(local maincoq {1 :ms-jpq/coq_nvim :branch :coq})
(local artscoq {1 :ms-jpq/coq.artifacts :branch :artifacts})
(local thrpcoq {1 :ms-jpq/coq.thirdparty :branch :3p})

(local ultautopair {1 :altermo/ultimate-autopair.nvim
                    :envet [:InsertEnter :CmdlineEnter]
                    :branch :v0.6
                    :opts {}})

(local theme {1 :rose-pine/neovim
              :name :rose-pine
              :config (fn []
                        (let [{: setup} (require :rose-pine)] (setup {}))
                        (vim.cmd "colorscheme rose-pine")
                        ;; making cursorline stand out more
                        (vim.api.nvim_set_option_value :cursorline true {})
                        (let [{:nvim_get_hl ghl :nvim_set_hl shl} vim.api
                              cl :CursorLine
                              clnr :CursorLineNr
                              cl-hl (ghl 0 {:name cl})
                              clnr-hl (ghl 0 {:name clnr})]
                          (tset cl-hl :bold true)
                          (tset clnr-hl :bg (. cl-hl :bg))
                          (shl 0 cl cl-hl)
                          (shl 0 clnr clnr-hl)))})

(local which-key
       {1 :folke/which-key.nvim
        :event :VeryLazy
        :opts {}
        :config (fn []
                  (let [{: setup} (require :which-key)] (setup {})))})

(local telescope {1 :nvim-telescope/telescope.nvim
                  :tag :0.1.6
                  :dependencies [:nvim-lua/plenary.nvim]})

(local lsp [:neovim/nvim-lspconfig])

(local surround
       {1 :kylechui/nvim-surround
        :config (fn []
                  (let [{: setup} (require :nvim-surround)] (setup {})))})

(local blankline
       {1 :lukas-reineke/indent-blankline.nvim
        :main :ibl
        :opts {}
        :config (fn []
                  (let [{: setup} (require :ibl)] (setup {})))})

(local com {1 :numToStr/Comment.nvim :opts {} :lazy false})

(local lualine {1 :nvim-lualine/lualine.nvim
                :opts {:options {:icons_enabled false
                                 :component_separators "|"
                                 :section_separators ""}}})

(let [{: setup} (require :lazy)]
  (setup [hotpot
          oil
          treesitter
          guard
          maincoq
          artscoq
          thrpcoq
          ultautopair
          theme
          which-key
          telescope
          lsp
          surround
          blankline
          com
          lualine])
  {})

(fn wkregister [tbl]
  (let [{: register} (require :which-key)] (register tbl)))

(fn register-keymap [[grp name & bindings] prefix?]
  (let [tbl {: name}]
    (fn inner [[key func desc & rest]]
      (when key
        (tset tbl key [func desc])
        (inner rest)))

    (inner bindings)
    (if prefix? (wkregister {prefix? tbl})
        (wkregister {grp tbl :prefix :<leader>}))))

(let [{: setup : open : close : open_float} (require :oil)]
  (setup {:view_options {:show_hidden true}})
  (register-keymap [:o
                    "[O]il"
                    :o
                    open
                    "[O]pen"
                    :c
                    close
                    "[C]lose"
                    :f
                    open_float
                    "Open [F]loat"]))

(local hp-eval-buff
       (let [{: eval-buffer} (require :hotpot.api.eval)]
         (fn []
           (eval-buffer (vim.api.nvim_get_current_buf)))))

(let [{: Now} (require :coq)]
  (Now))

;; diagnostics are not LSP dependent
(let [{: open_float : goto_next : goto_prev} vim.diagnostic]
  (register-keymap [:d
                    "[D]iagnostics"
                    :o
                    open_float
                    "[O]pen float"
                    :n
                    goto_next
                    "[N]ext"
                    :p
                    goto_prev
                    "[P]revious"]))

(fn make-lsp-keymaps [additional?]
  (let [{: hover
         : definition
         : declaration
         : implementation
         : type_definition
         : references
         : signature_help
         : rename
         : code_action} vim.lsp.buf]
    (register-keymap [""
                      "[L]SP"
                      :g
                      hover
                      "[H]over"
                      :d
                      definition
                      "[D]efintion"
                      :D
                      declaration
                      "[D]eclaration"
                      :i
                      implementation
                      "[I]mplementation"
                      :t
                      type_definition
                      "[T]ype"
                      :rr
                      references
                      "[R]eferences"
                      :s
                      signature_help
                      "[S]ignature Help"
                      :rn
                      rename
                      "[R]e-[N]ame"
                      :a
                      code_action
                      "[C]ode Action"] :g)
    (if additional?
        (register-keymap additional?))))

(fn setup-lsp [{: lsp : config}]
  (let [{: setup} (. (require :lspconfig) lsp)
        {: lsp_ensure_capabilities} (require :coq)]
    (setup (lsp_ensure_capabilities config))))

(setup-lsp {:lsp :fennel_ls
            :config {:settings {:fennel-ls {:extra-globals :vim}}
                     :on_attach (fn []
                                  (make-lsp-keymaps [:h
                                                     "[H]otpot"
                                                     :b
                                                     (fn []
                                                       (hp-eval-buff))
                                                     "Eval [B]uffer"]))}})

(let [{: setup : load_extension} (require :telescope)
      builtin (require :telescope.builtin)
      themes (require :telescope.themes)]
  (setup {:defaults {:mappings {:i {:<C-u> false :<C-d> false}}}})
  (pcall load_extension :fzf)
  (let [{: oldfiles
         : buffers
         : current_buffer_fuzzy_find
         : git_files
         : find_files
         : help_tags
         : grep_string
         : live_grep
         : diagnostics
         : resume} builtin]
    (wkregister {:<leader>? [oldfiles "[?] Find recently opened files"]})
    (wkregister {:<leader><space> [buffers "[  ] Find open buffers"]})

    (fn fzf-find []
      (current_buffer_fuzzy_find (themes.get_dropdown {:windblend 10
                                                       :previewer false})))

    (wkregister {:/ [fzf-find "[/] Fuzzy search in buffer"]})
    (register-keymap [:f
                      "[F]ind"
                      :f
                      find_files
                      "[F]iles"
                      :h
                      help_tags
                      "[H]elp"
                      :w
                      grep_string
                      "[W]ord"
                      :g
                      live_grep
                      "Live [G]rep"
                      :d
                      diagnostics
                      "[D]iagnostics"
                      :r
                      resume
                      "[R]esume"])
    (register-keymap [:g "[G]it" :f git_files "[F]iles"])))

(let [{: setup} (require :guard)
      {: do_fmt} (require :guard.format)
      ft (require :guard.filetype)]
  (-> (ft :fennel)
      (: :fmt :fnlfmt))
  (-> (ft :nix)
      (: :fmt :nixfmt))
  (-> (ft :rust)
      (: :fmt :rustfmt))
      (-> (ft "*")
          (: :lint :codespell))
      (setup {:fmt_on_save false :lsp_as_default_formatter false})
      (register-keymap [:a "[A]ction" :f do_fmt "[F]ormat"]))

