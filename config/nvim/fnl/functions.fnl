(fn selection-coords-fixed []
  (let [{: getpos} vim.fn
        [_ lstart cstart _] (getpos :v)
        [_ lend cend _] (getpos ".")
        [lstart cstart lend cend] (icollect [_ v (ipairs [lstart
                                                          cstart
                                                          lend
                                                          cend])]
                                    (- v 1))]
    (match [(<= 0 (- lend lstart)) (<= 0 (- cend cstart))]
      [true true] [lstart cstart lend (if (= cstart cend) -1 cend)]
      [false false] [lend cend lstart lend]
      [true false] [lstart cend lend cstart]
      [false true] [lend cstart lstart cend])))

(fn selected-text []
  (let [{: nvim_buf_get_text} vim.api
        [lstart cstart lend cend] (selection-coords-fixed)]
    (nvim_buf_get_text 0 lstart cstart lend cend {})))

(fn replace-selected-text [new-text]
  (let [{: nvim_buf_set_text} vim.api
        [lstart cstart lend cend] (selection-coords-fixed)]
    (nvim_buf_set_text 0 lstart cstart lend cend new-text)))

(fn first-rest-of-word [word]
  [(string.sub word 1 1) (string.sub word 2 -1)])

(fn capitalize-word [word]
  (let [{: upper : lower} string
        [first rest] (first-rest-of-word word)]
    (.. (upper first) (lower rest))))

(fn capitalize-word-callback [strs]
  (icollect [_ str (ipairs strs)]
    (string.gsub str "([^%w]*)(%w+)([^%w]*)"
                 (fn [a b c] (.. a (capitalize-word b) c)))))

(fn snake-to-camel-one-iter [s]
  (string.gsub s "([^%w]*)(%w+)_(%w+)"
               (fn [a b c]
                 (.. (if (= a "-") "" a) (capitalize-word b)
                     (capitalize-word c)))))

(fn snake-to-camel-callback [strs]
  (icollect [_ str (ipairs strs)]
    (let [t {:prev-str nil :new-str nil}]
      (set t.new-str str)
      (while (not (= (. t :prev-str) (. t :new-str)))
        (set t.prev-str (. t :new-str))
        (set t.new-str (snake-to-camel-one-iter (. t :new-str))))
      (. t :new-str))))

(fn replace-selecteion [modifier-callback]
  (let [new-text (modifier-callback (selected-text))]
    (replace-selected-text new-text)))

(fn snake-to-camel [] (replace-selecteion snake-to-camel-callback))
(fn capitalize [] (replace-selecteion capitalize-word-callback))

{: snake-to-camel : capitalize}

