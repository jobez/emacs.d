;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.

(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(let ((default-directory  "~/.emacs.d/custom/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

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
(load "johannsync.el")
;; the lab
(load "lab.el")



;; packages
(load "js.el")
(load "scribble.el")

;;key stuff
(setq ns-function-modifier 'hyper)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-p") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
