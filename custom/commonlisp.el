(add-to-list 'load-path "~/exps/langs/lisp/common/deps/slime")
(require 'slime-autoloads)
(require 'slime)

(slime-setup '(slime-fancy))
(setq inferior-lisp-program "sbcl-media")
(global-set-key "\C-cs" 'slime-selector)

(add-to-list 'load-path "/home/jmsb/exps/langs/lisp/common/web/css/LASS/")
(require 'lass)

(require 'cl)
;; https://www.reddit.com/r/lisp/comments/5osi1d/dont_loop_iterate_the_iterate_manual/dclzg24/
(with-eval-after-load 'lisp-mode
  (font-lock-add-keywords
   'lisp-mode
   '(("\\<\\(defn\\)\\>" . font-lock-keyword-face)
     ("\\<\\(bind\\)\\>" . font-lock-keyword-face)
     ("\\<\\(lambda-bind\\)\\>" . font-lock-keyword-face)
     ("\\<\\(lambda-registers\\)\\>" . font-lock-keyword-face)
     ("\\<\\(when-let\\)\\>" . font-lock-keyword-face)
   ("\\<\\(if-let\\)\\>" . font-lock-keyword-face)
     ("(\\(iter\\(ate\\)?\\|defmacro-\\(driver\\|clause\\)\\)[[:space:]\n]" 1 'font-lock-keyword-face)
     ("(i\\(ter\\(ate\\)?\\|n\\)\\s-+\\([^()\\s-]+\\)" 3 'font-lock-constant-face)
     ("(\\(f\\(or\\|in\\(ish\\|ally\\(-protected\\)?\\)\\)\\|generate\\|w\\(hile\\|ith\\)\\|until\\|repeat\\|leave\\|next-iteration\\|i\\(n\\(itially\\)?\\|f-first-time\\)\\|after-each\\|else\\)[[:space:]\n)]" 1 'font-lock-keyword-face)
     ("(define-constant\\s-+\\(\\(\\sw\\|\\s_\\)*\\)" 1 'font-lock-variable-name-face))
   t))

(defun slime-style-init-command (port-filename _coding-system extra-args)
  "Return a string to initialize Lisp."
  (let ((loader (if (file-name-absolute-p slime-backend)
                    slime-backend
                  (concat slime-path slime-backend))))
    ;; Return a single form to avoid problems with buffered input.
    (format "%S\n\n"
            `(progn
               (load ,(slime-to-lisp-filename (expand-file-name loader))
                     :verbose t)
               (funcall (read-from-string "swank-loader:init"))
               (funcall (read-from-string "swank:start-server")
                        ,(slime-to-lisp-filename port-filename)
            ,@extra-args)))))

(defun slime-style (&optional style)
  (interactive
   (list (intern-soft (read-from-minibuffer "Style: " "nil"))))
  (lexical-let ((style style))
    (slime-start
     :init )))

(setq
 slime-lisp-implementations
 '((sbcl
    ("sbcl"))
   (clasp
    ("clasp"))
   (sbcl-media-singlethread
    ("sbcl-media") :coding-system utf-8-unix
    :init (lambda (x y)
                                                                                    (slime-style-init-command
                                                                                     x y `(:style nil :dont-close t))))
   ;; (sbcl-media-singlethread
   ;;  ("sbcl-media"
   ;;   "--core"
   ;;   "/home/jmsb/exps/langs/lisp/common/scratch/creative/flow/kiss/kiss") :coding-system utf-8-unix
   ;;  :init (lambda (x y)
   ;;          (slime-style-init-command
   ;;           x y `(:style nil :dont-close t))))
   (sbcl-media
    ("sbcl-media"))

   (primus-sbcl-media
    ("primusrun" "sbcl-media"))

   (guccigang
    ("primusrun" "sbcl-media" "--core"  "/home/jmsb/exps/langs/lisp/common/scratch/creative/guccigang"))

   (phaneron
    ("primusrun" "sbcl-media" "--core"  "/home/jmsb/exps/langs/lisp/common/scratch/creative/phaneron"))

   (sbcl-media-nix
    ("nix-shell" "/home/jmsb/exps/dev/env/mmedia.nix" "--run" "sbcl")
    :coding-system utf-8-unix)
   (clisp
    ("clisp"))
   (ecl
    ("ecl"))
   (eql
    ("eql"))
   (abcl
    ("abcl"))
   (ccl
    ("ccl"))))



(setq slime-scratch-file "~/exps/langs/lisp/common/scratch/riff/cursor.lsp")

(defun emacs-forget-buffer-process ()
  "Emacs will not query about this process when killing."
  (let ((p (get-buffer-process (current-buffer))))
    (when p
      (set-process-query-on-exit-flag p nil))))

(add-hook 'slime-inferior-process-start-hook #'emacs-forget-buffer-process)
(add-hook 'slime-repl-mode-hook #'emacs-forget-buffer-process)

(load "~/quicklisp/log4slime-setup.el")
(global-log4slime-mode 1)
;; (load  "~/exps/langs/lisp/common/overlord/overlord/elisp/overlord.el")
(load  "~/exps/langs/lisp/common/compilec/c-mera/util/emacs/cm-mode.el")




;; (load  "~/exps/langs/lisp/common/analysis/fricas/build/lib/fricas/emacs/fricas-cpl.el")
;; (load  "~/exps/langs/lisp/common/analysis/fricas/build/lib/fricas/emacs/fricas.el")

;; (setf fricas-run-command "/home/jmsb/exps/langs/lisp/common/analysis/fricas/build/lib/fricas/target/x86_64-linux-gnu/bin/fricas")
