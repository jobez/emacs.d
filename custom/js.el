(add-to-list 'auto-mode-alist `(,(rx ".js" string-end) . js2-mode))

;; tern

(add-hook 'js2-mode-hook (lambda () (tern-mode t)))

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;; web-beautify

(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

;; marshall's stuff

(defun my-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(custom-set-variables '(js2-basic-offset 2))

(add-hook 'js2-mode-hook 'my-paredit-nonlisp) ;use with the above function

(eval-after-load "js2-mode"
 '(progn
    (define-key js2-mode-map "{" 'paredit-open-curly)
    (define-key js2-mode-map "}" 'paredit-close-curly-and-newline)))
