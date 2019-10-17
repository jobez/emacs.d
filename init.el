;; User pack init file
;;
;; Use this file to initiate the pack configuration.
;; See README for more information.


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;(package-initialize)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

 (add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

(defmacro customs (&rest custom-list)
  `(progn
     ,@(mapcar (lambda (name)
                `(load ,(cl-concatenate 'string "~/.emacs.d/custom/" name ".el")))
              custom-list)))

(customs "orgcustom"
         "commonlisp"
         ;; "reason"
         "general"
         "dev")
(customs "general"
         "dev"
         ;; "cust-exwm"
         "tex_settings"
         "navigation"
         "clojure"
         "clojurescript"
         "cust-haskell"
         "shen"
         "orgcustom"
         "extemporecustom"
         "purescript"
         "cm-mode"
         "arcadia"
         "schemelisp"
         "picocust"
         "lab")
;; customs

(find-file "~/orgs/structure/emptyground.org")

;; packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84508a4c4b0cccdb89c98ae39438d792003826e1d371b75b706d74826048f0fb" default)))
 '(debug-on-error t)
 '(haskell-process-type (quote chosen-process-type))
 '(package-selected-packages
   (quote
    (ox-gfm org org-brain highlight-symbol ejc-sql gmail-message-mode orgit polymode bongo org-randomnote dhall-mode ob-hy helm-recoll linguistic org-dp el-get define-word spray org-noter org-mind-map magit exwm-x intero dante anki-editor ob-clojurescript ob-go org-ref shen-elisp org-pdfview pdf-tools inform-mode org-plus-contrib calfw-org ediprolog ob-prolog exwm-edit gpastel outshine direnv helm-bibtex fennel-mode org-download transpose-frame org-attach-screenshot poet-theme forth-mode sclang-snippets sclang-extensions ox-pandoc lua-mode faustine haxe-mode haxe-imports dired-toggle-sudo ox-hugo wc-mode wc-goal-mode org-wc spiral counsel-projectile counsel-css ac-rtags helm scala-mode hierarchy gradle-mode osc autodisass-llvm-bitcode nim-mode utop merlin typescript-mode restclient pacmacs omnisharp csharp-mode axiom-environment ob-async shader-mode rust-mode solidity-mode skewer-less skewer-reload-stylesheets trident-mode ox-tufte idris-mode scribble-mode zenburn-theme zenburn yaml-mode xresources-theme writeroom-mode win-switch web-mode vala-mode undo-tree tuareg tern-auto-complete tagedit systemd sml-mode smex smartparens smart-mode-line-powerline-theme shm shen-mode servant scss-mode scratch sage-shell-mode rvm request rainbow-mode rainbow-delimiters racket-mode quelpa quack python-mode psci psc-ide project-explorer prodigy pallet org-present org-pomodoro org-dashboard noflet nodejs-repl nix-sandbox nix-mode nginx-mode neotree mustache-mode muse moe-theme mode-compile markdown-mode mark-multiple manage-minor-mode macrostep load-dir llvm-mode less-css-mode latex-preview-pane jsx-mode js2-refactor ivy-hydra interleave inf-ruby inf-clojure imgur ido-vertical-mode ido-ubiquitous hyperbole hy-mode httprepl htmlize hlint-refactor hindent hi2 graphviz-dot-mode grandshell-theme google go-mode gist geiser fountain-mode flymake-yaml flymake-jshint flymake-cursor flycheck-pos-tip flycheck-clojure flx-ido find-file-in-project faust-mode extempore-mode expand-region exec-path-from-shell eval-sexp-fu ereader eink-theme edit-server dracula-theme dockerfile-mode djvu deft dash-at-point company-nixos-options company-ghci company-ghc column-marker color-theme-buffer-local color-theme coffee-mode cmake-mode clojure-quick-repls clojure-mode-extra-font-locking clj-refactor bm avy-migemo auctex ag ace-window ace-jump-mode)))
 '(safe-local-variable-values
   (quote
    ((eval add-hook
           (quote before-save-hook)
           (function clang-format-buffer)
           nil t)
     (eval define-clojure-indent
           (codepoint-case
            (quote defun)))
     (Package . metabang\.graph)
     (eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook"
           (add-hook
            (quote write-contents-functions)
            (lambda nil
              (delete-trailing-whitespace)
              nil))
           (require
            (quote whitespace))
           "Sometimes the mode needs to be toggled off and on."
           (whitespace-mode 0)
           (whitespace-mode 1))
     (whitespace-style face tabs trailing lines-tail)
     (geiser-scheme-implementation . guile)
     (bug-reference-bug-regexp . "\\(\\(?:[Ii]ssue \\|[Ff]ixe[ds] \\|[Rr]esolve[ds]? \\|[Cc]lose[ds]? \\|[Pp]\\(?:ull [Rr]equest\\|[Rr]\\) \\|(\\)#\\([0-9]+\\))?\\)")
     (whitespace-style quote
                       (face trailing empty tabs))
     (whitespace-action)
     (Package . C)
     (nxml-outline-child-indent . 1)
     (nxml-child-indent . 1)
     (sgml-indent-step . 1)
     (sgml-parent-document . "ecl.xml")
     (Package . SYSTEM)
     (Package . make)
     (Package . HTTP)
     (Package . CL-USER)
     (Package . STELLA)
     (Package . user)
     (Package ap5 lisp)
     (Package . AP5)
     (Lowercase . T)
     (common-lisp-style . poem)
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (bug-reference-bug-regexp . "<https?://\\(debbugs\\|bugs\\)\\.gnu\\.org/\\([0-9]+\\)>")
     (Package . DWIM)
     (Package . CLOUSEAU)
     (Package . GRAPH)
     (Syntax . Common-lisp)
     (Package . CLIM-LISTENER)
     (Package . FLEXI-STREAMS)
     (Package . CLIM-USER)
     (Package . snark)
     (Package . snark-dpll)
     (Package . snark-user)
     (Package: . CL-USER)
     (org-babel-lilypond-nix-ly-path . "/usr/local/bin/lilypond")
     (Package . cells)
     (common-lisp-style . modern)
     (Package . WOLFCOIN-ECDSA)
     (Package . WOLFCOIN-API)
     (Package . WOLFCOIN-WALLET)
     (Package . WOLFCOIN)
     (Syntax . COMMON-LISP)
     (Package . common-lisp-user)
     (Syntax . ansi-common-lisp)
     (Package . XML)
     (Package . MCCLIM-FREETYPE)
     (Lowercase . Yes)
     (Package . CLIM-DEMO)
     (Syntax . Common-Lisp)
     (Package . CLIM-INTERNALS)
     (Package . BORDEAUX-FFT)
     (Package ITERATE :use "COMMON-LISP" :colon-mode :external)
     (syntax . COMMON-LISP)
     (indent-tabs)
     (Package . bind)
     (Syntax . ANSI-Common-Lisp)
     (Base . 10)
     (c-file-offsets
      (innamespace . 0)
      (substatement-open . 0)
      (c . c-lineup-dont-change)
      (inextern-lang . 0)
      (comment-intro . c-lineup-dont-change)
      (arglist-cont-nonempty . c-lineup-arglist)
      (block-close . 0)
      (statement-case-intro . ++)
      (brace-list-intro . ++)
      (cpp-define-intro . +))
     (c-auto-align-backslashes)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;; (when (window-system)
;;   (set-default-font "Fira Code"))
