(add-to-list 'auto-mode-alist `(,(rx ".js" string-end) . js2-mode))

;; tern

(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode t)
                           (paredit-mode t)
                           (electric-pair-mode t)))

(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))

;; marshall's stuff

(defun my-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(add-hook 'js2-mode-hook 'my-paredit-nonlisp) ;use with the above function

(eval-after-load "js2-mode"
  '(progn
     (define-key js2-mode-map "{" 'paredit-open-curly)
     (define-key js2-mode-map "}" 'paredit-close-curly-and-newline)))
