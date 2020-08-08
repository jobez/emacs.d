;; (use-package direnv
;;   :config
;;   (setq direnv-always-show-summary nil)
;;  (direnv-mode))

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

;; (setq erc-autojoin-channels-alist

;;       '("freenode.net"
;;           "#clasp"
;;           "#lispgames"))

(add-to-list 'load-path "~/exps/langs/hk/creative/Tidal")

(add-to-list 'load-path "~/exps/emacs/scel/el")


(setq sclang-runtime-directory "/home/jmsb/.local/share/SuperCollider")

(use-package tidal
  :config
  (setq tidal-interpreter "stack")
  (setq tidal-interpreter-arguments '("exec"
                                      "--package"
                                      "tidal"
                                      "--"
                                      "ghci"))
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

(use-package om
  :load-path "~/.emacs.d/elpa/om.el")

(use-package pymacs
  :load-path "~/exps/langs/python/Pymacs"
  :config
  (setq pymacs-python-command "/nix/store/cl9mwqpwhaqvxrmc78k9g8cj3zpdic13-python3-3.7.6-env/bin/python3.7"))

(add-to-list 'load-path "~/exps/langs/java/smsn/smsn-mode/lisp/lib")
(add-to-list 'load-path "~/exps/langs/java/smsn/smsn-mode/lisp")

(defun hey-smsn ()
  (interactive)
  (let ((vbuff (shell (get-buffer-create "*smsn*")))
        (smsn-root (get-buffer-create "*smsn-root*")))
    (process-send-string vbuff "cd ~/exps/langs/java/smsn/apache-tinkerpop-gremlin-server-3.2.5/")
    (process-send-string vbuff "\C-m")
    (process-send-string vbuff "./bin/gremlin-server.sh conf/jhnn-smsn.yaml")
    (process-send-string vbuff "\C-m")
    (sleep-for 5)
    (with-current-buffer smsn-root
      (smsn-mode)
      (smsn-find-roots))))

(use-package smsn-mode
  :config
  (setq smsn-server-protocol "websocket")
  ;; use "http" or "websocket"
  (setq smsn-server-host "localhost")
  (setq smsn-server-port 8182)
  (setq smsn-default-graphml-file "~/orgs/structure/smsn.xml"))

(defun export-smsn! ()
  (interactive)
  (smsn-write-yaml)
  (sleep-for 0.5)
  (let ((vbuff (shell (get-buffer-create "smsn-export"))))
    (process-send-string vbuff "cp -r ~/exps/langs/java/smsn/apache-tinkerpop-gremlin-server-3.2.5/data/sources/private/ ~/orgs/structure/smsn/")
    (process-send-string vbuff "\C-m")
    (process-send-string vbuff "exit")
    (process-send-string vbuff "\C-m")
    (kill-buffer vbuff)))

(comment
 (quelpa
  '(quelpa-use-package
    :fetcher git
    :url "https://github.com/quelpa/quelpa-use-package.git")))


(require 'quelpa-use-package)

(use-package bufler
  :quelpa (bufler :fetcher github :repo "alphapapa/bufler.el")
  :config
  (setq bufler-face-prefix
        "prism-level-"))

(comment
 (require 'prism)
 (bufler-mode))
(require 'nov)


(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(defun init-mic! ()
  (interactive)
  (let ((vbuff (shell (get-buffer-create "*h4-mic*"))))
    (process-send-string vbuff "alsa_in -d hw:H4,0 -j H4")
    (process-send-string vbuff "\C-m")
    (switch-to-buffer
     vbuff nil 'force-same-window)))

(defun connect-mic ()
  (interactive)
  (let ((vbuff (shell (get-buffer-create "*mic-connection*"))))
    (process-send-string vbuff "jack_connect H4:capture_1 incudine:in_1")
    (process-send-string vbuff "\C-m")
    (process-send-string vbuff "jack_connect H4:capture_2 incudine:in_2")
    (process-send-string vbuff "\C-m")
    (process-send-string vbuff "jack_connect H4:capture_1 'JACK Input Client-01:in_1'")
    (process-send-string vbuff "\C-m")
    (process-send-string vbuff "jack_connect H4:capture_2 'JACK Input Client-01:in_2'")
    (process-send-string vbuff "\C-m")))

(use-package eleutherios
  :init (progn
          (add-to-list 'load-path "~/exps/langs/lisp/clojure/scratch/exo/eleutherios/src/elisp/")
          (setq *eleuetherios-project-dir* "~/exps/langs/lisp/clojure/scratch/exo/eleutherios/")
          (defun ivy-shrink-after-dispatching ()
            "Shrink the window after dispatching when action list is too large."
            ;; (window-resize nil (- ivy-height (window-height)))
            )))

(defun defunkpdf (b e)
  (interactive "r")
  (replace-string "
"
                  " " nil b e)
  (replace-string "¬" "" nil b e)

  (replace-string "ﬁ" "fi" nil b e)
  (replace-string "ﬂ" "fl" nil b e)
  ;; (footnotify b e)
  )

(defun defunkpdf (b e)
  (interactive "r")
  ;; (replace-string "
;; "
;;                   " " nil b e)
  (replace-string "�" "ö" nil b e)

  (replace-string "�" "é" nil b e)
  (replace-string "�" "·" nil b e)
  (replace-string "" "" nil b e)
  (replace-string "�" "æ" nil b e)
  ;; (replace-string "ﬂ" "fl" nil b e)
  ;; (footnotify b e)
  )



;; (defun ora-swiper ()
;;   (interactive)
;;   (if (and (buffer-file-name)
;;            (not (ignore-errors
;;                   (file-remote-p (buffer-file-name))))
;;            (if (eq major-mode 'org-mode)
;;                (> (buffer-size) 60000)
;;              (> (buffer-size) 300000)))
;;       (progn
;;         (save-buffer)
;;         (counsel-grep))
;;     (swiper--ivy (swiper--candidates))))

(defun toggle-mode-line () "toggles the modeline on and off"
  (interactive) 
  (setq mode-line-format
    (if (equal mode-line-format nil)
        (default-value 'mode-line-format)) )
  (redraw-display))

(global-set-key [f12] 'toggle-mode-line)

;; (setq custom-initialize-delay 3.5)
;; (setq eldoc-idle-delay 0.5)

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


(defvar gdocs-folder-id "0B3kOusyMeFLVRXZ3QnpOb2x2eVE"
"location for storing org to gdocs exported files, use 'gdrive list  -t <foldername>' to find the id")

(defun gdoc-upload-buffer-to-gdrive ()
  "Export current buffer to gdrive folder identified by gdocs-folder-id"
  (interactive)
  (shell-command
   (format "gdrive upload --parent %s %s"
           gdocs-folder-id buffer-file-name)))  
