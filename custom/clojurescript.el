(require 'cider)

(setq inf-clojure-generic-cmd "/home/jmsb/exps/langs/lisp/clojure/cljs/planck/planck-c/build/planck -d")


(setq cljs-repls (make-hash-table :test 'equal))

(puthash  "browser" "(do (require 'weasel.repl.websocket) (cemerick.piggieback/cljs-repl (weasel.repl.websocket/repl-env :ip \"127.0.0.1\" :port 9001)))"  cljs-repls)

(puthash "rhino" "(cemerick.piggieback/cljs-repl (cljs.repl.rhino/repl-env))" cljs-repls)

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
                               :reload-ns 'rfz.mobilenext.ios.core)]
  (cemerick.piggieback/cljs-repl repl-env)))" cljs-repls)

(puthash "rfz-fig-ios" "(do (require '[rfz.cljs-build.figwheel :as fg])
(fg/repl-start-dev :rfz-rn [:ios]))" cljs-repls)

(defun hash-table-keys (hash-table)
  (let ((keys ()))
    (maphash (lambda (k v) (push k keys)) hash-table)
    keys))

(setq cljs-repl-keys
      `((name . "CLJS repl modes")
        (candidates . ,(hash-table-keys cljs-repls))
        (action . (lambda (candidate)
                    (helm-marked-candidates)))))
;; this gives you a cljs repl interactive prompt before jacking in with a clojurescript buffer

(defun repls-with-cljs-prompt ()
  (interactive)
  (setq cider-cljs-repl (gethash (first (helm :sources '(cljs-repl-keys))) cljs-repls))
  (cider-jack-in-clojurescript))

;; cant use piggieback and watch for file changes :(
;; https://github.com/cemerick/piggieback/issues/61

;; so this stuff is a hack to get the ambly repl to reload
;; a user defined main namespace

(defun safe-command (clj-expr)
  (goto-char (point-max))
  (insert clj-expr)
  (goto-char (point-max))
  (cider-repl-return)
  (sit-for 1))

(defun relaunch-simulator (repl-type)
  (interactive "sreboot into which cljs repl: ")
  (save-window-excursion
    (shell-command "killall Simulator")
    (async-shell-command "/Users/johannbestowrous/rfz/debtapp/app/mobilescripts/devtime \"iPhone 6\" \"8.4\""))
  (with-current-buffer (cider-current-repl-buffer)

    (goto-char (point-max))
    (insert "(ra/stop-autobuild)")
    (cider-repl-return)
    (sit-for 1)
    (goto-char (point-max))
    (insert "(ra/stop-figwheel!)")
    (cider-repl-return)
    ))

(defun restart-figwheel ()
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (safe-command ":cljs/quit")
    (safe-command "(ra/stop-autobuild)")
    (safe-command "(ra/stop-figwheel!)")
    (safe-command "(repl-start-dev :rfz-rn [:ios])")))

(defun reload-main-ns ()
  (interactive)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(reload!)")
    (cider-repl-return)))

(defun save-and-reload-ns ()
  (interactive)
  (save-buffer)
  (reload-main-ns))

(defun planck-inject-if (process output)
  (let* ((evaled (first (split-string output))))
    (progn
      (message evaled)
      (when buffer-inject
        (backward-kill-sexp)
        (insert evaled)))))

(defun planck-init nil
  (interactive)
  (setq buffer-inject nil)
  (when (not (get-process "planck-init"))
    (start-process-shell-command "planck-init" "planck-proc" "planck")
    (set-process-filter (get-process "planck-init") 'planck-inject-if))
  (message "planck a go go"))

(defun planck-eval-replace nil
  (interactive)
  (if (not (get-process "planck-init"))
      (message "planck not started")
    (let* ((last-sexp (cider-last-sexp)))
      (setq buffer-inject t)
      (process-send-string "planck-init" (concat  last-sexp
                                                  "\n")))))

(global-set-key (kbd "H-p r") 'planck-eval-replace)

(global-set-key (kbd "H-p i") #'planck-init)

(add-hook 'cider-mode-hook (lambda ()
                             (local-set-key (kbd "H-.") #'repls-with-cljs-prompt)))

(add-hook 'rfz-mode-hook (lambda ()
                             (local-set-key (kbd "H-,") #'reload-main-ns)))

(add-hook 'rfz-mode-hook (lambda ()
                             (local-set-key (kbd "H-/") #'save-and-reload-ns)))
