(require 'cider)



(setq cljs-repls (make-hash-table :test 'equal))

(puthash  "browser" "(do (require 'weasel.repl.websocket) (cemerick.piggieback/cljs-repl (weasel.repl.websocket/repl-env :ip \"127.0.0.1\" :port 9001)))"  cljs-repls)

(puthash "ambly" "(do (require '[cljs.repl :as repl])
(require '[ambly.core :as ambly])
(let [repl-env (ambly.core/repl-env :choose-first-discovered true)]
  (cemerick.piggieback/cljs-repl repl-env
                                 :watch \"src/rfz/mobilenext/\"
                                 :watch-fn
                                 (fn []
                                     (cljs.repl/load-file repl-env
                                                          \"src/rfz/mobilenext/core.cljs\"))
                                 :analyze-path \"src\")))" cljs-repls)

(puthash "rfz-ios" "(do (require '[cljs.repl :as repl])
(require '[rfz.mobilenext.rfz-jsc-env :as rfz-env])
(let [repl-env (rfz-env/repl-env :choose-first-discovered true
                               :reload-ns 'rfz.mobilenext.core)]
  (cemerick.piggieback/cljs-repl repl-env)))" cljs-repls)

;; this gives you a cljs repl interactive prompt before jacking in with a clojurescript buffer

(defun repls-with-cljs-prompt (repl-type)
  (interactive "scljs repl type: ")
  (setq cider-cljs-repl (gethash repl-type cljs-repls))
  (cider-jack-in-clojurescript))

;; cant use piggieback and watch for file changes :(
;; https://github.com/cemerick/piggieback/issues/61

;; so this stuff is a hack to get the ambly repl to reload
;; a user defined main namespace

(defun reload-main-ns ()
  (interactive)
  (cider-switch-to-current-repl-buffer)
  (cider-insert "(reload!)")
  (cider-repl-return))

(defun save-and-reload-ns ()
  (interactive)
  (save-buffer)
  (reload-main-ns))

(add-hook 'cider-mode-hook (lambda ()
                             (local-set-key (kbd "C-x .") #'repls-with-cljs-prompt)))

(add-hook 'cider-mode-hook (lambda ()
                             (local-set-key (kbd "C-x ,") #'reload-main-ns)))

(add-hook 'cider-mode-hook (lambda ()
                             (local-set-key (kbd "C-x /") #'save-and-reload-ns)))
