(use-package direnv
  :config
  (setq direnv-always-show-summary nil)
 (direnv-mode))

;;;; outline mode


(add-hook 'outline-minor-mode-hook 'outshine-mode)

;; Enables outline-minor-mode for *ALL* programming buffers
(add-hook 'prog-mode-hook 'outline-minor-mode)

;; Must be set before outline is loaded
(defvar outline-minor-mode-prefix "\M-#")

;;;; this is necessary for orgout in haskell, future johann

(setq outshine-preserve-delimiter-whitespace t)

(use-package outorg)

(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(require 'epa-file)

(defun eshell-brace-expansion (str)
  (let* ((parts (split-string str "[{}]"))
         (prefix (car parts))
         (body   (nth 1 parts))
         (suffix (nth 2 parts)))
    (mapcar (lambda (x) (concat prefix x suffix))
            (split-string body ","))))

(setq erc-autojoin-channels-alist

      '("freenode.net"
          "#clasp"
          "#lispgames"))

(add-to-list 'load-path "~/exps/langs/hk/creative/Tidal")

(add-to-list 'load-path "~/exps/emacs/scel/el")


(setq sclang-runtime-directory "/home/jmsb/.local/share/SuperCollider")

(use-package tidal
  :config
  (setq tidal-boot-script-path "/home/jmsb/exps/langs/hk/creative/Tidal/BootTidal.hs"))

(use-package sclang
  :config
  (setq sclang-program "sclang"))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :defer t
  :config
  ;; If pdf-tools is installed using emacsWithPackage in nix, then the
  ;; `epdfinfo` binary is installed alongside the elisp package.
  (setq pdf-info-epdfinfo-program
        (concat (file-name-directory (locate-library "pdf-tools"))
                "epdfinfo")
        pdf-info-epdfinfo-error-filename nil)
  (pdf-tools-install))

(use-package shen-mode)

;; (require 'ejc-sql)

;; (ejc-create-connection
;;  "yes"
;;  :classpath (concat "~/.m2/repository/org/postgresql/postgresql/42.2.7/"
;;                     "postgresql-42.2.7.jar")
;;  :subprotocol "postgresql"
;;  :subname "//localhost:5432/yes"
;;  :user "yessir"
;;  :password "yessir")


;; (use-package inferior-shen)

;; (find-file pdf-info-epdfinfo-program)

;; (use-package hyperbole)

;; (setq mode-line-format nil)
