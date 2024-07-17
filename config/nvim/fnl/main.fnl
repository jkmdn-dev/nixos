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
                    (setup {:ensure_installed [:zig
                                               :nix
                                               :fennel
                                               :nu
                                               :lua
                                               :c
                                               :cpp
                                               :rust
                                               :markdown
                                               :vimdoc]
                            "ignore_install:" [:neorg]
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

(local nvim-nu {1 :LhKipp/nvim-nu
                :build ":TSInstall nu"
                :dependencies [:nvim-treesitter/nvim-treesitter]
                :config (fn []
                          (let [{: setup} (require :nu)]
                            (setup {:use_lsp_features false})))})

(local guard {1 :nvimdev/guard.nvim :dependencies [:nvimdev/guard-collection]})

(local luasnip {1 :L3MON4D3/LuaSnip
                :version :v2.2
                :build "make install_jsregexp"})

(local cmp {1 :hrsh7th/nvim-cmp
            :version false
            :event [:InsertEnter :CmdlineEnter]
            :dependencies [:hrsh7th/cmp-nvim-lsp
                           :hrsh7th/cmp-buffer
                           :hrsh7th/cmp-path
                           :hrsh7th/cmp-cmdline
                           :hrsh7th/cmp-nvim-lsp-document-symbol
                           :hrsh7th/cmp-nvim-lsp-signature-help
                           luasnip
                           :saadparwaiz1/cmp_luasnip
                           :zjp-CN/nvim-cmp-lsp-rs
                           {:url "https://codeberg.org/FelipeLema/cmp-async-path.git"}
                           :lukas-reineke/cmp-rg
                           :andersevenrud/cmp-tmux
                           :Saecki/crates.nvim]
            :config (fn []
                      (let [{: config} (require :luasnip)
                            {: setup} config
                            {: lazy_load} (require :luasnip.loaders.from_vscode)]
                        (lazy_load)
                        (setup))
                      (let [{: setup : mapping : config : ConfirmBehavior} (require :cmp)
                            {: preset
                             : scroll_docs
                             : complete
                             : abort
                             : confirm
                             : select_next_item
                             : select_prev_item} mapping
                            {: Replace} ConfirmBehavior
                            {: insert} preset
                            {: sources} config
                            {: cmdline} setup
                            {: locally_jumpable
                             : jump
                             : expand_or_locally_jumpable
                             : expand_or_jump} (require :luasnip)
                            cmdline-src1 (sources [{:name :buffer}])
                            cmdline-src2 (sources [{:name :cmdline}])
                            completion {:completeopt "menu,menuone,noinsert"}
                            snippet {:expand (fn [{: body}]
                                               (let [{: lsp_expand} (require :luasnip)]
                                                 (lsp_expand body)))}
                            mapping (insert {:<C-b> (scroll_docs (- 4))
                                             :<C-f> (scroll_docs 4)
                                             :<C-Space> (complete {})
                                             :<C-e> (abort)
                                             :<CR> (confirm {:behaviour Replace
                                                             :select true})
                                             :<C-n> (select_next_item)
                                             :<C-p> (select_prev_item)
                                             :<C-l> (mapping (fn []
                                                               (if (expand_or_locally_jumpable)
                                                                   (expand_or_jump))))
                                             :<C-h> (mapping (fn []
                                                               (if (locally_jumpable (- 1))
                                                                   (jump (- 1)))))})
                            sources (sources [{:name :nvim_lsp
                                               :max_item_count 5}
                                              {:name :luasnip
                                               :max_item_count 2}
                                              {:name :nvim_lsp_document_symbol
                                               :max_item_count 2}
                                              {:name :nvim_lsp_signature_help
                                               :max_item_count 2}
                                              {:name :buffer :max_item_count 2}
                                              {:name :rg :max_item_count 2}
                                              {:name :tmux :max_item_count 2}])
                            experimental {:ghost_text true}]
                        (setup {: snippet
                                : mapping
                                : sources
                                : completion
                                : experimental})
                        (cmdline "/"
                                 {:mapping ((. preset :cmdline))
                                  :sources cmdline-src1})
                        (cmdline "?"
                                 {:mapping ((. preset :cmdline))
                                  :sources cmdline-src1})
                        (cmdline ":"
                                 {:mapping ((. preset :cmdline))
                                  :sources cmdline-src2})))})

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

(local codeactionpreview [:aznhe21/actions-preview.nvim])

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

(local autosave
       {1 :pocco81/auto-save.nvim
        :config (fn []
                  (let [{: setup} (require :auto-save)]
                    (setup {:trigger_events [:QuitPre]
                            :condition (fn [buf]
                                         (let [{: getbufvar} vim.fn]
                                           (if (and (= (getbufvar buf
                                                                  :&modifiable)
                                                       1)
                                                    (getbufvar buf :&filetype))
                                               true
                                               false)))})))})

; (local copilot
;        {1 :zbirenbaum/copilot.lua
;         :cmd :Copilot
;         :event :InsertEnter
;         :config (fn []
;                   (let [{: setup} (require :copilot)]
;                     (setup {:panel {:enabled true
;                                     :auto_refresh false
;                                     :keymap {:jump_prev :<c-space><c-p>
;                                              :jump_next :<c-space><c-n>
;                                              :accept :<c-space><c-space>
;                                              :refresh :<c-space>cr
;                                              :open :<c-space>co}
;                                     :layout {:position :bottom :ratio 0.4}}
;                             :suggestion {:enabled true
;                                          :auto_trigger false
;                                          :debounce 75
;                                          :keymap {:accept :<c-space><c-y>
;                                                   :accept_word :<c-space><c-w>
;                                                   :accept_line :<c-space><c-l>
;                                                   :next :<c-space><c-n>
;                                                   :prev :<c-space><c-n>
;                                                   :dismiss :<c-space><c-d>}}
;                             :filetypes {:yaml false
;                                         :markdown false
;                                         :help false
;                                         :gitcommit false
;                                         :gitrebase false
;                                         :hgcommit false
;                                         :svn false
;                                         :cvs false}
;                             :copilot_node_command :node})))})

(local glow {1 :ellisonleao/glow.nvim :config true :cmd :Glow})

(local licences {1 "https://git.sr.ht/~reggie/licenses.nvim"
                 :config (fn []
                           (let [{: setup} (require :licenses)]
                             (setup {:copyright_holder "Joakim Paulsson"
                                     :email "jkmdn@proton.me"
                                     :licence :MIT})))})

(local supermaven {1 :supermaven-inc/supermaven-nvim
                   :config (fn []
                             (let [{: setup} (require :supermaven-nvim)]
                               (setup {})))})

(let [{: setup} (require :lazy)]
  (setup [hotpot
          oil
          treesitter
          nvim-nu
          guard
          cmp
          ultautopair
          theme
          which-key
          telescope
          lsp
          codeactionpreview
          surround
          blankline
          com
          lualine
          autosave
          ; copilot
          glow
          licences
          supermaven])
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

(let [{: snake-to-camel : capitalize} (require :functions)]
  (wkregister {:m {:name "[M]odify selection"
                   :s [(fn [] (snake-to-camel)) "[S]nake to camel"]
                   :c [(fn [] (capitalize)) "[C]apitalize"]}
               :mode [:v :n]}))

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
         : rename} vim.lsp.buf]
    (register-keymap [""
                      :LSP
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
                      "[R]e-[N]ame"] :g)
    (if additional?
        (register-keymap additional?))))

(local capabilities (let [{: default_capabilities} (require :cmp_nvim_lsp)]
                      (default_capabilities)))

(fn setup-lsp [{: lsp : config}]
  (let [{: setup} (. (require :lspconfig) lsp)
        {: on_attach : settings} config]
    (setup {: on_attach : settings : capabilities})))

(setup-lsp {:lsp :fennel_ls
            :config {:settings {:fennel-ls {:extra-globals :vim}}
                     :on_attach (fn []
                                  (make-lsp-keymaps [:h
                                                     "[H]otpot"
                                                     :b
                                                     (fn []
                                                       (hp-eval-buff))
                                                     "Eval [B]uffer"]))}})

(setup-lsp {:lsp :rust_analyzer
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable 0)
                                  (make-lsp-keymaps))}})

(setup-lsp {:lsp :zls
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable 0)
                                  (make-lsp-keymaps))}})

(setup-lsp {:lsp :nil_ls
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable 0)
                                  (make-lsp-keymaps))}})

(setup-lsp {:lsp :nushell
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable 0)
                                  (make-lsp-keymaps))}})

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

(let [{: setup : code_actions} (require :actions-preview)
      layout_config {:width 0.8
                     :height 0.9
                     :prompt_position :top
                     :preview_cutoff 20
                     :preview_height (fn [_a _b max_lines] (- max_lines 15))}
      telescope {:sorting_strategy :ascending
                 :layout_strategy :vertical
                 : layout_config}]
  (setup {: telescope})
  (register-keymap ["" :LSP :a code_actions "Code [A]ctions"] :g))

(let [{: setup} (require :guard)
      {: do_fmt} (require :guard.format)
      ft (require :guard.filetype)]
  (-> (ft :fennel)
      (: :fmt :fnlfmt))
  (-> (ft :nix)
      (: :fmt :nixfmt))
  (-> (ft :nu)
      (: :fmt :lsp))
  (-> (ft :rust)
      (: :fmt {:cmd :rustfmt :args [:--emit :stdout :-q]}))
  (-> (ft :zig))
  (-> (ft "*")
      (: :lint :codespell))
  (setup {:fmt_on_save false :lsp_as_default_formatter false})
  (register-keymap [:a "[A]ction" :f do_fmt "[F]ormat"]))

