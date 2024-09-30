(fn wk_add [lst]
  (let [{: add} (require :which-key)] (add lst)))

(local kb-group-leader (.. :<leader> :a))
(local kb-group {1 kb-group-leader :group :Ollama})

(fn get-gen-util []
  (let [gen (require :ollamachad.generate)
        util (require :ollamachad.util)]
    {: gen : util}))

(fn get-chat []
  (let [Chat (require :ollamachad.chat)]
    (Chat:new {:keymap {:clear :<C-n> :send :<CR> :quit :<ESC> :select :<C-k>}
               :system_prompt ""})))

(fn kb-toggle []
  (let [chat (get-chat)
        toggle [(.. kb-group-leader :T) (fn [] (chat:toggle))]]
    (tset toggle :desc :Toggle)
    (wk_add [kb-group toggle])))

(fn codeqwen-visual-prompt [instruction]
  (let [{: gen : util} (get-gen-util)
        {: prompt} gen
        {: read_visiual_lines} util]
    (let [request {:model :codeqwen
                   :prompt (.. instruction (read_visiual_lines))}]
      (prompt request))))

(fn kb-rewrite []
  (let [mode [:v]
        rewrite [(.. kb-group-leader :r)
                 (fn []
                   (codeqwen-visual-prompt "Rewrite the following code to reduce complexity and imporve stabillity:"))]]
    (tset rewrite :desc :Rewrite)
    (wk_add [{: mode} kb-group rewrite])))

(fn kb-test []
  (let [mode [:v]
        tests [(.. kb-group-leader :t)
               (fn []
                 (codeqwen-visual-prompt "Write tests for the following code with as high of a code coverage as possible:"))]]
    (tset tests :desc "Write tests")
    (wk_add [{: mode} kb-group tests])))

{:ollamachad {1 :Lommix/ollamachad.nvim
              :dependencies [:MunifTanjim/nui.nvim
                             :nvim-lua/plenary.nvim
                             :nvim-telescope/telescope.nvim]
              :config (fn []
                        (let [{: setup} (require :ollamachad)]
                          (setup {:api_url "http://localhost:11434/api"})
                          (kb-toggle)
                          (kb-rewrite)
                          (kb-test)))}}

