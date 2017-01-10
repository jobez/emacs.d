(require 'slime)
(slime-setup '(slime-fancy))
(setq inferior-lisp-program "sbcl-media")

(global-set-key "\C-cs" 'slime-selector)

(require 'cl)

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
     :init (lambda (x y)
         (slime-style-init-command
          x y `(:style ,style :dont-close t))))))


(setq slime-scratch-file "~/exps/langs/lisp/common/scratch/riff/cursor.lsp")

(defun emacs-forget-buffer-process ()
  "Emacs will not query about this process when killing."
  (let ((p (get-buffer-process (current-buffer))))
    (when p
      (set-process-query-on-exit-flag p nil))))

(add-hook 'slime-inferior-process-start-hook #'emacs-forget-buffer-process)
(add-hook 'slime-repl-mode-hook #'emacs-forget-buffer-process)
