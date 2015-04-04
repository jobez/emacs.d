;;jshint mode
(require 'flymake-jshint)
(add-hook 'js2-mode-hook
     (lambda () (flymake-mode t)))

;; mode hooks
(add-to-list 'auto-mode-alist '("\\.jst\\.tpl$" . html-mode))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))
