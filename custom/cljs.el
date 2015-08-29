(require 'cider)

(setq cljs-repls (make-hash-table :test 'equal))

(puthash  "browser" "(do (require 'weasel.repl.websocket) (cemerick.piggieback/cljs-repl (weasel.repl.websocket/repl-env :ip \"127.0.0.1\" :port 9001)))"  cljs-repls)

(puthash "ambly" "(do (require '[cljs.repl :as repl])
(require '[ambly.core :as ambly])
(let [repl-env (ambly.core/repl-env)]
  (cljs.repl/repl repl-env
                  :watch \"src\"
                  :watch-fn
                  (fn []
                      (cljs.repl/load-file repl-env
                                           \"src/rfz/mobilenext/core.cljs\"))
                  :analyze-path \"src\")))"  cljs-repls)

(defun repls-with-cljs-prompt (repl-type)
  (interactive "scljs repl type: ")
  (setq cider-cljs-repl (gethash repl-type cljs-repls))
  (cider-jack-in-clojurescript))

(add-hook 'cider-mode-hook (lambda ()
                             (local-set-key (kbd "C-x .") #'repls-with-cljs-prompt)))
