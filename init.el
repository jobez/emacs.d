;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'load-path "~/.emacs.d/custom/packages")

;; customs
(load "general.el")
(load "tex_settings.el")
(load "helmcustoms.el")
(load "clojure.el")
(load "clojurescript.el")
(load "haskell.el")
(load "shen.el")
(load "js.el")
(load "rfz.el")
(load "web-markup.el")
(load "commonlisp.el")

;; packages
(load "js.el")

;;key stuff
(setq ns-function-modifier 'hyper)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-p") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

(defun live-paredit-delete-horizontal-space ()
  (interactive)
  (just-one-space -1)
  (paredit-backward-delete))

(define-key paredit-mode-map (kbd "s-\\") 'live-paredit-delete-horizontal-space)

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(global-set-key (kbd "s-z") 'eval-and-replace)
