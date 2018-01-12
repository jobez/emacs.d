;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "/Users/JMSB/.cask/cask.el")
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
