;;; clojure-repls.el --- Assign repls for clj and cljs eval

;; Copyright (C) 2015 Dylan Butman

(require 'cider)
(require 'dash)

(defvar clojure-repls-clj-con-buf nil)
(defvar clojure-repls-cljs-con-buf nil)

(defadvice cider-connect (around stfu activate)
      (flet ((yes-or-no-p (&rest args) t)
             (y-or-n-p (&rest args) t))
        ad-do-it))

(defadvice save-some-buffers (around stfu activate)
      (flet ((yes-or-no-p (&rest args) t)
             (y-or-n-p (&rest args) t))
        ad-do-it))

(defun cider-insert (buff fs)
  (save-some-buffers t)
  (with-current-buffer (or buff (cider-current-repl-buffer))
    (goto-char (point-max))
    (insert fs)
    (cider-repl-return)))

(defun clojure-repls-bound-truthy-p (s)
  (and (boundp s) (symbol-value s)))

(defun clojure-repls-clear-con-bufs ()
  (setq clojure-repls-cljs-con-buf nil)
  (setq clojure-repls-clj-con-buf nil))

(defun clojure-repls-kill-buffer (buff)
  (let ((nrepl (get-buffer-process buff)))
    (set-process-query-on-exit-flag nrepl nil))
  (kill-buffer buff))

(defun clojure-repls-quit ()
  (interactive)
  (when (clojure-repls-bound-truthy-p 'clojure-repls-cljs-con-buf)
    (cider-insert clojure-repls-cljs-con-buf ":cljs/quit")
    (clojure-repls-kill-buffer clojure-repls-cljs-con-buf))
  (when (clojure-repls-bound-truthy-p 'clojure-repls-clj-con-buf)
    (clojure-repls-kill-buffer clojure-repls-clj-con-buf))
  (clojure-repls-clear-con-bufs))

(defun clojure-repls-set-clj-buffer ()
  (interactive)
  (setq clojure-repls-clj-con-buf (current-buffer)))

(defun clojure-repls-set-cljs-buffer ()
  (interactive)
  (setq clojure-repls-cljs-con-buf (current-buffer)))

(defun clojure-repls-new-repl-connection ()
  (let* ((host (nrepl-current-host))
         (port (nrepl-extract-port)))
    (message "Creating repl connection to nrepl server  on port %s, host %s" host port)
    (cider-connect host port)))

(defun clojure-repls-create-repls ()
  (interactive)
  (clojure-repls-clear-con-bufs)
  (clojure-repls-new-repl-connection)
  (cider-insert nil "(start-repl)")
  (setq clojure-repls-cljs-con-buf (nrepl-current-connection-buffer))
  (clojure-repls-new-repl-connection)
  (setq clojure-repls-clj-con-buf (nrepl-current-connection-buffer))
  (nrepl-make-connection-default (nrepl-current-connection-buffer)))

(defun clojure-repls-buffer-extension (buffer)
  (let ((name (buffer-name buffer)))
    (-when-let (p-loc (string-match-p "\\." name))
      (substring name (1+ p-loc) nil))) )

(defun clojure-repls-set-connection (f h)
  (let ((ext (clojure-repls-buffer-extension (current-buffer))))
    (if (and (clojure-repls-bound-truthy-p 'clojure-repls-clj-con-buf)
             (clojure-repls-bound-truthy-p 'clojure-repls-cljs-con-buf)
             ext
             (or (string= ext "clj") (string= ext "boot") (string= ext "cljs")))
        (progn
          (if (string= ext "cljs")
              (nrepl-make-connection-default clojure-repls-cljs-con-buf)
            (nrepl-make-connection-default clojure-repls-clj-con-buf))
          (when f
            (funcall f)))
      (when h
        (funcall h)))))

(defun clojure-repls-switch-to-relevant-repl (arg)
  (interactive)
  (lexical-let ((a arg))
    (clojure-repls-set-connection (lambda () (cider-switch-to-current-repl-buffer a))
                                        (lambda () (cider-switch-to-relevant-repl-buffer a)))))

(if (version< emacs-version "24.4")
    (progn
      (defadvice cider-interactive-eval (before clojure-repls-nrepl-current-session activate)
        (clojure-repls-set-connection nil nil))
      (defadvice cider-tooling-eval (before clojure-repls-nrepl-current-session activate)
        (clojure-repls-set-connection nil nil))
      (defadvice cider-complete-at-point (before clojure-repls-nrepl-current-session activate)
        (clojure-repls-set-connection nil nil)))
  (defun clojure-repls-nrepl-current-session (&optional arg1 arg2)
    (clojure-repls-set-connection nil nil))
  (advice-add 'cider-interactive-eval :before #'clojure-repls-nrepl-current-session)
  (advice-add 'cider-tooling-eval :before #'clojure-repls-nrepl-current-session)
  (advice-add 'cider-complete-at-point :before #'clojure-repls-nrepl-current-session))

(defun clojure-repls-system-reset ()
  (interactive)
  (clojure-repls-set-connection nil nil)
  (cider-insert nil "(boot-component.reloaded/reset)"))

(global-set-key (kbd "C-c M-b") 'clojure-repls-create-repls)
(global-set-key (kbd "C-c r") 'clojure-repls-system-reset)
(global-set-key (kbd "C-c C-r") 'clojure-repls-system-reset)
(global-set-key (kbd "C-c C-q") 'clojure-repls-quit)
(setq cider-switch-to-repl-command 'clojure-repls-switch-to-relevant-repl)

(provide 'clojure-repls)
