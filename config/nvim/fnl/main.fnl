(require :general-settings)
(local {: kb_telescope
        : kb_lsp
        : kb_diag
        : kb_supermaven
        : kb_ufo
        : kb_prepl
        : kb_oil
        : kb_fns
        : kb_codeactions
        : kb_guard
        : kb_hotpot} (require :keybindings))

(local hotpot {1 :rktjmp/hotpot.nvim
               :opts {}
               :config (fn [opts]
                         (let [{: setup} (require :hotpot)] (setup opts)
                           (kb_hotpot)))})

(local oil {1 :stevearc/oil.nvim
            :opts {:view_options {:show_hidden false}}
            :config (fn [opts]
                      (let [{: setup} (require :oil)] (setup opts))
                      (kb_oil))
            :dependencies [:nvim-tree/nvim-web-devicons]})

(local treesitter
       {1 :nvim-treesitter/nvim-treesitter
        :build ":TSUpdate"
        :dependencies [:nvim-treesitter/nvim-treesitter-textobjects
                       :nvim-treesitter/nvim-treesitter-context]
        :config (fn []
                  (let [{: setup} (require :nvim-treesitter.configs)
                        parsers [:zig
                                 :nix
                                 :fennel
                                 :nu
                                 :lua
                                 :c
                                 :cpp
                                 :cmake
                                 :rust
                                 :toml
                                 :python
                                 :markdown
                                 :html
                                 :css
                                 :javascript
                                 :typescript
                                 :vue
                                 :vimdoc]]
                    (setup {:ensure_installed parsers
                            "ignore_install:" [:neorg]
                            :sync_install false
                            :highlight {:enable true}
                            :indent {:enable true}
                            :incremental_selection {:enable true
                                                    :keymaps {:init_selection :<c-space>
                                                              :node_incremental :<c-space>
                                                              :node_decremental :<c-bs>}}
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
                :opts {:use_lsp_features false}})

(local guard
       {1 :nvimdev/guard.nvim
        :dependencies [:nvimdev/guard-collection]
        :config (fn [opts]
                  (let [{: setup} (require :guard)]
                    (setup opts)
                    (kb_guard)
                    (let [ft (require :guard.filetype)]
                      (-> (ft :fennel)
                          (: :fmt :fnlfmt))
                      (-> (ft :nix)
                          (: :fmt :nixfmt))
                      (-> (ft :nu)
                          (: :fmt :lsp))
                      (-> (ft :rust)
                          (: :fmt {:cmd :rustfmt :args [:--emit :stdout :-q]}))
                      (-> (ft :zig))
                      (-> (ft :html)
                          (: :fmt :prettierd))
                      (-> (ft :typescript)
                          (: :fmt :prettierd))
                      (-> (ft :javascript)
                          (: :fmt :prettierd))
                      (-> (ft :javascriptreact)
                          (: :fmt :prettierd))
                      (-> (ft :typescriptreact)
                          (: :fmt :prettierd))
                      (-> (ft :css)
                          (: :fmt :prettierd))
                      (-> (ft :python)
                          (: :fmt :lsp))
                      (-> (ft "*")
                          (: :lint :codespell)))))
        :opts {:fmt_on_save true :lsp_as_default_formatter false}})

(local luasnip {1 :L3MON4D3/LuaSnip
                :version :v2.2
                :opts {}
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
                           :luckasRanarison/tailwind-tools.nvim
                           :onsails/lspkind-nvim
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
                            mapping (insert {:<A-j> (scroll_docs (- 4))
                                             :<A-k> (scroll_docs 4)
                                             :<C-e> (abort)
                                             :<C-y> (confirm {:behaviour Replace
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
                                               :max_item_count 10}
                                              {:name :luasnip
                                               :max_item_count 2}
                                              {:name :nvim_lsp_document_symbol
                                               :max_item_count 2}
                                              {:name :nvim_lsp_signature_help
                                               :max_item_count 2}
                                              {:name :buffer :max_item_count 2}
                                              {:name :rg :max_item_count 2}
                                              {:name :tmux :max_item_count 2}])
                            experimental {:ghost_text false}
                            {: cmp_format} (require :lspkind)
                            {: lspkind_format} (require :tailwind-tools.cmp)
                            formatting {:format (cmp_format {:before lspkind_format})}]
                        (setup {: snippet
                                : mapping
                                : sources
                                : completion
                                : experimental
                                : formatting})
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
              :lazy false
              :priority 1000
              :opts {}
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

(local mini-icons {1 :echasnovski/mini.icons :version false :opts {}})

(local which-key {1 :folke/which-key.nvim
                  :event :VeryLazy
                  :dependencies [:echasnovski/mini.icons]
                  :opts {}
                  :config (fn [opts]
                            (let [{: setup} (require :which-key)]
                              (setup opts)
                              (kb_fns)
                              (kb_diag)))})

(local telescope-fzf-native
       {1 :nvim-telescope/telescope-fzf-native.nvim
        :build "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release; cmake --build build --config Release"})

(local telescope
       {1 :nvim-telescope/telescope.nvim
        :tag :0.1.8
        :config (fn [opts]
                  (let [{: setup} (require :telescope)]
                    (setup opts)
                    (kb_telescope)))
        :opts {:defaults {:mappings {:i {:<C-u> false :<C-d> false}}}
               :extensions {:fzf {:fuzzy true
                                  :override_generic_sorter true
                                  :override_file_sorter true
                                  :case_mode :smart_case}}}
        :dependencies [:nvim-lua/plenary.nvim
                       :nvim-telescope/telescope-fzf-native.nvim]})

(local lsp {1 :neovim/nvim-lspconfig :dependencies [:kevinhwang91/nvim-ufo]})

(local codeactionpreview
       {1 :aznhe21/actions-preview.nvim
        :config (fn [opts]
                  (let [{: setup} (require :actions-preview)]
                    (setup opts)
                    (kb_codeactions)))
        :opts {:telescope {:sorting_strategy :ascending
                           :layout_strategy :vertical
                           :layout_config {:width 0.8
                                           :height 0.9
                                           :prompt_position :top
                                           :preview_cutoff 20
                                           :preview_height (fn [_a
                                                                _b
                                                                max_lines]
                                                             (- max_lines 15))}}}})

(local surround {1 :kylechui/nvim-surround :opts {}})

(local blankline {1 :lukas-reineke/indent-blankline.nvim :main :ibl :opts {}})

(local com {1 :numToStr/Comment.nvim :opts {} :lazy false})

(local lualine {1 :nvim-lualine/lualine.nvim
                :opts {:options {:icons_enabled false
                                 :component_separators "|"
                                 :section_separators ""}}})

(local autosave {1 :pocco81/auto-save.nvim
                 :opts {:trigger_events [:QuitPre]
                        :condition (fn [buf]
                                     (let [{: getbufvar} vim.fn]
                                       (if (and (= (getbufvar buf :&modifiable)
                                                   1)
                                                (getbufvar buf :&filetype))
                                           true
                                           false)))}})

(local glow {1 :ellisonleao/glow.nvim :opts {} :cmd :Glow})

(local licences {1 "https://git.sr.ht/~reggie/licenses.nvim"
                 :opts {:copyright_holder "Joakim Paulsson"
                        :email "jkmdn@proton.me"
                        :licence :MIT}})

(local supermaven {1 :supermaven-inc/supermaven-nvim
                   :config (fn []
                             (let [{: setup} (require :supermaven-nvim)]
                               (setup {:keymaps {:accept_suggestion :<C-f>
                                                 :clear_suggestion :<C-BS>
                                                 :accept_word :<C-A-f>}
                                       :disable-keymaps true})
                               (kb_supermaven)))
                   :opts {}})

(local ufo {1 :kevinhwang91/nvim-ufo
            :dependencies [:kevinhwang91/promise-async]
            :init kb_ufo
            :opts {}})

(local nvim-python-repl {1 :geg2102/nvim-python-repl
                         :dependencies [:nvim-treesitter/nvim-treesitter
                                        :folke/which-key.nvim]
                         :ft [:python :lua :scala]
                         :opts {}
                         :config (fn [opts]
                                   (let [{: setup} (require :nvim-python-repl)]
                                     (setup opts)
                                     (kb_prepl)))})

(local wp-diagnostics {1 :artemave/workspace-diagnostics.nvim
                       :opts {}
                       :ft [:javascript
                            :javascriptreact
                            :typescript
                            :typescriptreact
                            :css
                            :html]})

(local tailwind-tools {1 :luckasRanarison/tailwind-tools.nvim
                       :name :tailwind-tools
                       :build ":UpdateRemotePlugins"
                       :ft [:html
                            :css
                            :javascript
                            :javascriptreact
                            :typescript
                            :typescriptreact]
                       :dependencies [:nvim-treesitter/nvim-treesitter
                                      :nvim-telescope/telescope.nvim
                                      :neovim/nvim-lspconfig]
                       :opts {}})

(local codecompanion {1 :olimorris/codecompanion.nvim
                      :dependencies {1 :nvim-lua/plenary.nvim
                                     2 :nvim-treesitter/nvim-treesitter
                                     3 :hrsh7th/nvim-cmp
                                     {1 :stevearc/dressing.nvim :opts []} :nvim-telescope/telescope.nvim}
                      :config true})

( vim.api.nvim_set_keymap "n" "<C-a>" "<cmd>CodeCompanionActions<cr>" { :noremap true :silent true })
( vim.api.nvim_set_keymap "v" "<C-a>" "<cmd>CodeCompanionActions<cr>" { :noremap true :silent true })
( vim.api.nvim_set_keymap "n" "<LocalLeader>cc" "<cmd>CodeCompanionToggle<cr>" { :noremap  true :silent true })
( vim.api.nvim_set_keymap "v" "<LocalLeader>cc" "<cmd>CodeCompanionToggle<cr>" { :noremap  true :silent true })
( vim.api.nvim_set_keymap "v" "ga" "<cmd>CodeCompanionAdd<cr>" { :noremap  true :silent  true })

(let [{: setup} (require :lazy)]
  (setup [hotpot
          oil
          treesitter
          nvim-nu
          guard
          cmp
          ultautopair
          theme
          mini-icons
          which-key
          telescope-fzf-native
          telescope
          lsp
          codeactionpreview
          surround
          blankline
          com
          lualine
          autosave
          glow
          licences
          supermaven
          ufo
          nvim-python-repl
          wp-diagnostics
          tailwind-tools
          codecompanion
          ])
  {})

(fn setup-lsp [{: lsp : config}]
  (let [{: setup} (. (require :lspconfig) lsp)
        ufo (require :ufo)
        {: on_attach : settings} config
        capabilities (let [{: default_capabilities} (require :cmp_nvim_lsp)]
                       (default_capabilities))]
    (tset capabilities :textDocument :foldingRange
          {:dynamicRegistration false :lineFoldingOnly true})
    (setup {: on_attach : settings : capabilities})
    ((. ufo :setup))))

(setup-lsp {:lsp :fennel_ls
            :config {:settings {:fennel-ls {:extra-globals :vim}}
                     :on_attach (fn []
                                  (kb_lsp))}})

(setup-lsp {:lsp :rust_analyzer
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :zls
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :nil_ls
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :nushell
            :config {:on_attach (fn []
                                  (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :html
            :config {:on_attach (fn [] (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :tsserver
            :config {:on_attach (fn [client buffer]
                                  (let [{: populate_workspace_diagnostics} (require :workspace-diagnostics)]
                                    (populate_workspace_diagnostics client
                                                                    buffer))
                                  (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :tailwindcss
            :config {:on_attach (fn []
                                  (kb_lsp))}})

(setup-lsp {:lsp :cmake
            :config {:on_attach (fn [] (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :ruff
            :config {:on_attach (fn [] (vim.lsp.inlay_hint.enable true)
                                  (kb_lsp))}})

(setup-lsp {:lsp :pyright
            :settings {:pyright {:disableOrganizeImports true}
                       :python {:analysis {:ignore ["*"]
                                           :typeCheckingMode :off}}}
            :config {:on_attach (fn []
                                  (kb_lsp))}})

(let [{: nvim_create_autocmd : nvim_create_augroup} vim.api
      {: get_client_by_id} vim.lsp]
  (let [group (nvim_create_augroup :lsp_attach_ruff_stuff {:clear true})
        desc "LSP: Disable hover capabilities from ruff"
        callback (fn [{: data}]
                   (let [client (get_client_by_id (?. data :client_id))]
                     (if (not (= nil client))
                         (if (= (. client :name) :ruff)
                             (tset client :server_capabilities :hoverProvider
                                   false)))))]
    (nvim_create_autocmd :LspAttach {: group : callback : desc})))

