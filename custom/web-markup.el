;;jshint mode
(require 'flymake-jshint)
(require 'multiple-cursors)

;; mode hooks
(add-to-list 'auto-mode-alist '("\\.jst\\.tpl$" . html-mode))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

;; web-mode
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-markup-indent-offset 2)
