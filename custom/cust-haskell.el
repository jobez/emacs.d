(require 'haskell-mode)

;; (add-hook 'haskell-mode-hook 'hindent-mode)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))

(require 'haskell-interactive-mode)
(require 'haskell-process)


;; (remove-hook haskell-mode-hook 'intero-mode t)


;; (setq haskell-mode-hook '())

;; (remove-hook 'haskell-mode-hook 'flycheck-mode)
(setq haskell-process-log t)

(custom-set-variables '(haskell-process-type 'stack-ghci)
                      '(haskell-process-type 'chosen-process-type))

(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

;; (auto-load 'ghc-init "ghc" nil t)
;; (auto-load 'ghc-debug "ghc" nil t)
;; (add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(defun haskell-process-load-buffer (orig-fun &rest args)
  (if (and (buffer-file-name) (not org-src-mode))
      ;; The buffer is associated with a file, and is not a transient Org mode
      ;; code buffer, so the file *should* only contain Haskell code.
      ;; In which case, call the original function.
      (apply orig-fun args)
    ;; The alternative is that the buffer is not associated with a Haskell
    ;; file and its contents should be saved to a temporary file.
    (let* ((buffer (current-buffer))
           (body (buffer-string))
           (tmp-prefix "haskell-load-")
           (tmp-suffix ".hs")
           (tmp-file
            (if org-src-mode
                ;; Org Babel has its own temp-file functions.
                (concat (org-babel-temp-file tmp-prefix) tmp-suffix)
              ;; Create a normal Emacs temporary file.
              (make-temp-file tmp-prefix nil tmp-suffix))))
      (with-temp-buffer
        ;; Copy the contents of the original buffer into this temporary buffer
        ;; and save it to the newly-created temporary file.
        (insert body)
        (write-file tmp-file)
        ;; Instruct ghci to load this file, as per haskell-process-load-file.
        (haskell-interactive-mode-reset-error (haskell-session))
        (haskell-process-file-loadish
         (format "load \"%s\"" (replace-regexp-in-string
                                "\""
                                "\\\\\""
                                tmp-file))
         nil
         buffer)))))

;; Install a wrapper around the existing haskell-process-load-file function.
(advice-add 'haskell-process-load-file :around
            #'haskell-process-load-buffer)

;; (use-package dante
;;   :ensure t
;;   :after haskell-mode
;;   :commands 'dante-mode
;;   :init
;;   (add-hook 'haskell-mode-hook 'flycheck-mode)
;;   ;; OR:
;;   ;; (add-hook 'haskell-mode-hook 'flymake-mode)
;;   (add-hook 'haskell-mode-hook 'dante-mode)
;;   )
