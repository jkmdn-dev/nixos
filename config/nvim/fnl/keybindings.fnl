;; to enable lazy loading of which-key
(fn wk_add [lst]
  (let [{: add} (require :which-key)] (add lst)))

;; ---- hotpot ----
(fn kb_hotpot []
  (let [{: eval-buffer} (require :hotpot.api.eval) prefix (.. :<leader> :y)]
    (let [group [prefix]
          eval-buf [(.. prefix :b)
                    (fn []
                      (eval-buffer (vim.api.nvim_get_current_buf)))]]
      (tset group :group "[H]otpot")
      (tset eval-buf :desc "Eval [B]uffer")
      (wk_add [group eval-buf]))))

;; ---- supermaven-nvim ----
(fn kb_supermaven []
  (let [{: start
         : stop
         : restart
         : toggle
         : use_free_version
         : use_pro
         : logout
         : show_log
         : clear_log} (require :supermaven-nvim.api)
        prefix (.. :<leader> :s)]
    (let [group [prefix]
          start-sm [(.. prefix :s) (fn [] (start))]
          stop-sm [(.. prefix :S) (fn [] (stop))]
          restart-sm [(.. prefix :r) (fn [] (restart))]
          toggle-sm [(.. prefix :t) (fn [] (toggle))]
          use-free-ver [(.. prefix :f) (fn [] (use_free_version))]
          use-pro-ver [(.. prefix :p) (fn [] (use_pro))]
          logout-sm [(.. prefix :L) (fn [] (logout))]
          show-log [(.. prefix :l) (fn [] (show_log))]
          clear-log [(.. prefix :c) (fn [] (clear_log))]]
      (tset group :group "[S]upermaven")
      (tset start-sm :desc "[S]tart")
      (tset stop-sm :desc "[S]top")
      (tset restart-sm :desc "[R]estart")
      (tset toggle-sm :desc "[T]oggle")
      (tset use-free-ver :desc "[F]ree version")
      (tset use-pro-ver :desc "[P]ro version")
      (tset logout-sm :desc "[L]ogout")
      (tset show-log :desc "[L]og")
      (tset clear-log :desc "[C]lear log")
      (wk_add [group
               start-sm
               stop-sm
               restart-sm
               toggle-sm
               use-free-ver
               use-pro-ver
               logout-sm
               show-log
               clear-log]))))

;; ---- nvim-ufo ----
(fn kb_ufo []
  (let [{: closeAllFolds
         : openAllFolds
         : enable
         : disable
         : inspect
         : attach
         : detach
         : enableFold
         : disableFold} (require :ufo)
        prefix (.. :<leader> :u)]
    (let [group [prefix]
          enbl [(.. prefix :E) (fn [] (enable))]
          dis [(.. prefix :D) (fn [] (disable))]
          insp [(.. prefix :i) (fn [] (inspect))]
          att [(.. prefix :a) (fn [] (attach))]
          det [(.. prefix :d) (fn [] (detach))]
          en-fold [(.. prefix :e) (fn [] (enableFold))]
          dis-fold [(.. prefix :d) (fn [] (disableFold))]
          cls-all-folds [(.. prefix :c) (fn [] (closeAllFolds))]
          opn-all-folds [(.. prefix :o) (fn [] (openAllFolds))]]
      (tset group :group "[U]FOlding")
      (tset enbl :desc "[E]nable UFO")
      (tset dis :desc "[D]isable UFO")
      (tset insp :desc "[I]nspect")
      (tset att :desc "[A]ttach current buffer")
      (tset det :desc "[D]etach current buffer")
      (tset en-fold :desc "[E]nable folding and updating")
      (tset dis-fold :desc "[D]isable folding and updating")
      (tset opn-all-folds :desc "[O]pen all Folds")
      (tset cls-all-folds :desc "[C]lose all Folds")
      (wk_add [group
               enbl
               dis
               insp
               att
               det
               en-fold
               dis-fold
               opn-all-folds
               cls-all-folds]))))

;; ---- nvim-python-repl ----

;; fnlfmt: skip
(fn kb_prepl [] (let [{: send_statement_definition
           ; : send_visual_to_repl
           : send_buffer_to_repl
           : toggle_execute
           : toggle_vertical
           : toggle_prompt
           : open_repl} (require :nvim-python-repl)
           prefix (.. :<leader> :r) 
           ]
    (let [group [prefix]
                send-st [(.. prefix :s) (fn [] (send_statement_definition))]
                ; send-visual [(.. prefix :b) (fn [] (send_visual_to_repl))]
                send-buf [(.. prefix :b) (fn [] (send_buffer_to_repl))]
                toggle-exec [(.. prefix :e) (fn [] (toggle_execute))]
                toggle-vert [(.. prefix :v) (fn [] (toggle_vertical))]
                toggle-prompt [(.. prefix :p) (fn [] (toggle_prompt))]
                open-repl [(.. prefix :o) (fn [] (open_repl))]]
      (tset group :group "[R]epl")
      ; (tset send-visual :desc "[S]end Visual")
      ; (tset send-visual :mode [:v])
      (tset send-st :desc "Send [S]tatement")
      (tset send-buf :desc "Send [B]uffer") ;; codespell:ignore
      (tset toggle-exec :desc "Toggle [E]xecute")
      (tset toggle-vert :desc "Toggle [V]ertical")
      (tset toggle-prompt :desc "Toggle [P]rompt")
      (tset open-repl :desc "[O]pen Repl")
      (wk_add [group
             send-st
             send-buf
             toggle-exec
             toggle-vert
             toggle-prompt
             open-repl]))) )

;; ---- oil ----
(fn kb_oil []
  (let [{: open : close : open_float} (require :oil)
        prefix (.. :<leader> :o)]
    (let [group [prefix]
          open-oil [(.. prefix :o) (fn [] (open))]
          close-oil [(.. prefix :c) (fn [] (close))]
          open-flt-oil [(.. prefix :c) (fn [] (open_float))]]
      (tset group :group "[O]il")
      (tset open-oil :desc "[O]pen")
      (tset close-oil :desc "[C]lose")
      (tset open-flt-oil :desc "Open [F]loat")
      (wk_add [group open-oil close-oil open-flt-oil]))))

;; ---- diagnostic ----
(fn kb_diag []
  (let [{: open_float : goto_next : goto_prev} vim.diagnostic
        prefix (.. :<leader> :d)]
    (let [group [prefix]
          open-flt [(.. prefix :e) (fn [] (open_float))]
          nxt [(.. prefix :n) (fn [] (goto_next))]
          prv [(.. prefix :p) (fn [] (goto_prev))]]
      (tset group :group "[D]iagnostics")
      (tset open-flt :desc "Hover [E]rror")
      (tset nxt :desc "[N]ext")
      (tset prv :desc "[P]revious")
      (wk_add [group open-flt nxt prv]))))

;; ---- lsp ----
(fn kb_lsp []
  (let [{: hover
         : definition
         : declaration
         : implementation
         : type_definition
         : references
         : signature_help
         : rename} vim.lsp.buf
        prefix :g]
    (let [hvr [(.. prefix :h) (fn [] (hover))]
          def [(.. prefix :d) (fn [] (definition))]
          dec [(.. prefix :D) (fn [] (declaration))]
          impl [(.. prefix :i) (fn [] (implementation))]
          typ [(.. prefix :t) (fn [] (type_definition))]
          ref [(.. prefix :f) (fn [] (references))]
          sig [(.. prefix :s) (fn [] (signature_help))]
          rn [(.. prefix :rn) (fn [] (rename))]]
      (tset hvr :desc "[H]over")
      (tset def :desc "[D]efintion")
      (tset dec :desc "[D]eclaration")
      (tset impl :desc "[I]mplementation")
      (tset typ :desc "[T]ype")
      (tset ref :desc "[F]ind References")
      (tset sig :desc "[S]ignature Help")
      (tset rn :desc "[R]e-[N]ame")
      (wk_add [hvr def dec impl typ ref sig]))))

;; ---- telescope ----
(fn kb_telescope []
  (let [{: oldfiles
         : buffers
         : current_buffer_fuzzy_find
         : git_files
         : find_files
         : help_tags
         : grep_string
         : live_grep
         : diagnostic
         : resume} (require :telescope.builtin)
        {: get_dropdown} (require :telescope.themes)
        prefix (.. :<leader>)]
    (let [group [prefix]
          old-files [(.. prefix "?") (fn [] (oldfiles))]
          buf-find [(.. prefix :<space>) (fn [] (buffers))]
          cur-buf-find [(.. prefix "/")
                        (fn []
                          (current_buffer_fuzzy_find (get_dropdown {:winblend 10
                                                                    :previewer false})))]
          git-find [(.. prefix :g) (fn [] (git_files))]
          find-files [(.. prefix :f) (fn [] (find_files))]
          help-tags [(.. prefix :h) (fn [] (help_tags))]
          grep-string [(.. prefix :g) (fn [] (grep_string))]
          live-grep [(.. prefix :l) (fn [] (live_grep))]
          diagnostics [(.. prefix :d) (fn [] (diagnostic))]
          resume [(.. prefix :r) (fn [] (resume))]]
      (tset group :group "[F]ind")
      (tset old-files :desc "[?] Find recently opened files")
      (tset buf-find :desc "[  ] Find open [B]uffers")
      (tset cur-buf-find :desc "[/] Fuzzy find in current buffer")
      (tset git-find :desc "Find files in [G]it repository")
      (tset find-files :desc "[F]ind files")
      (tset help-tags :desc "[H]elp tags")
      (tset grep-string :desc "[G]rep string")
      (tset live-grep :desc "[L]ive grep")
      (tset diagnostics :desc "[D]iagnostics")
      (tset resume :desc "[R]esume previous search")
      (wk_add [group
               old-files
               buf-find
               cur-buf-find
               git-find
               find-files
               help-tags
               grep-string
               live-grep
               diagnostics
               resume]))))

;; ---- code-actions ----
(fn kb_codeactions []
  (let [{: code_actions} (require :actions-preview)
        prefix (.. :<leader> :c)]
    (let [group [prefix]
          code-actions [(.. prefix :a) (fn [] (code_actions))]]
      (tset group :group "[C]ode")
      (tset code-actions :desc "[A]ctions")
      (wk_add [group code-actions]))))

;; ---- gurad ----
(fn kb_guard []
  (let [{: do_fmt} (require :guard.format)
        prefix (.. :<leader> :c)]
    (let [group [prefix]
          fmt [(.. prefix :f) (fn [] (do_fmt))]]
      (tset group :group "[C]ode")
      (tset fmt :desc "[F]ormat")
      (wk_add [group fmt]))))

;; ---- functions ----
(fn kb_fns []
  (let [{: snake-to-camel : capitalize} (require :functions)]
    (let [prefix (.. :<leader> :m)
          group [prefix]
          mode [:v]
          snk-to-cml [(.. prefix :s) (fn [] (snake-to-camel))]
          cptl [(.. prefix :c) (fn [] (capitalize))]]
      (tset group :group "[M]odify selection")
      (tset snk-to-cml :desc "[S]nake to camel")
      (tset cptl :desc "[C]apitalize")
      (wk_add [{: mode} group snk-to-cml cptl]))))

{: kb_supermaven
 : kb_ufo
 : kb_prepl
 : kb_oil
 : kb_fns
 : kb_diag
 : kb_lsp
 : kb_telescope
 : kb_codeactions
 : kb_guard
 : kb_hotpot}

