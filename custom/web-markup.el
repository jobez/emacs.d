;; js

(setq js-indent-level 2)
(setq js2-basic-offset 2)
(setq-default js2-basic-offset 2)
(setq js2-highlight-external-variables nil)
(setq js2-mode-show-strict-warnings t)

;; js3-mode indentation

(setq js3-lazy-operators t)
(setq js3-expr-indent-offset 2)
(setq js3-paren-indent-offset 2)
(setq js3-square-indent-offset 2)
(setq js3-curly-indent-offset 2)

;; css indent
(setq css-indent-level 2)
(setq css-indent-offset 2)

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
