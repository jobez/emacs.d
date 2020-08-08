;;;; startup messages

(setq inhibit-startup-message t
      initial-scratch-message ""
      inhibit-startup-echo-area-message t)

;;;; appearance

(setq sml/no-confirm-load-theme t)
(load-theme 'zenburn t)
(sml/setup)

(global-undo-tree-mode)
(set-frame-parameter nil 'unsplittable t)

(global-visual-line-mode t)

;;;; indentation

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq tab-width 2)
(setq c-basic-indent 2)
(setq c-basic-offset 2)

;;;; autocomplete
(add-hook 'after-init-hook 'global-company-mode)

;;;; ffip
(setq ffip-limit 4096)
;; (setq ffip-patterns (append `("*.erb" "*.tpl" "*.php" "*.css" "*.ru" "*.json" "*.rb" "*.sass" "*.scss" "*.clj" "*.cljs") ffip-patterns))
(setq ffip-full-paths 1)

;;;; remove bells
(setq ring-bell-function 'ignore)

(defvar live-tmp-dir "~/.emacs.d/tmp/")
(defvar live-autosaves-dir "~/.emacs.d/autosaves/")
(defvar live-backups-dir "~/.emacs.d/backups/")

;;;; store history of recently opened files
(use-package recentf
  :bind ("C-x C-r" . counsel-recentf)
  :init
  (recentf-mode t)
  (setq recentf-max-saved-items 200))

;;When you visit a file, point goes to the last place where it was
;;when you previously visited. Save file is set to live-tmp-dir/places

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;;enable winner mode for C-c-(<left>|<right>) to navigate the history
;;of buffer changes i.e. undo a split screen
(when (fboundp 'winner-mode)
  (winner-mode 1))

(setq initial-major-mode 'lisp-interaction-mode
      redisplay-dont-pause t
      column-number-mode t
      echo-keystrokes 0.02
      ;; inhibit-startup-message t
      transient-mark-mode t
      shift-select-mode nil
      require-final-newline t
      truncate-partial-width-windows nil
      delete-by-moving-to-trash nil
      confirm-nonexistent-file-or-buffer nil
      query-replace-highlight t
      next-error-highlight t
      next-error-highlight-no-select t)

;;;;  set all coding systems to utf-8

(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;;;; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(setq utf-translate-cjk-mode nil)

(set-default 'indent-tabs-mode nil)
(auto-compression-mode t)
(show-paren-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

;;;; default to unified diffs
(setq diff-switches "-u"
      ediff-window-setup-function 'ediff-setup-windows-plain)

;;;; make emacs use the clipboard
(setq x-select-enable-clipboard t)

;;remove all trailing whitespace and trailing blank lines before
;;saving the file
;; (defvar live-ignore-whitespace-modes '(markdown-mode objc-mode))
;; (defun live-cleanup-whitespace ()
;;   (if (not (member major-mode live-ignore-whitespace-modes))
;;       (let ((whitespace-style '(trailing empty)) )
;;         (whitespace-cleanup))))

;; (add-hook 'before-save-hook 'live-cleanup-whitespace)

;; savehist keeps track of some history
(setq savehist-additional-variables
      ;; search entries
      '(search ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (concat live-tmp-dir "savehist"))
(savehist-mode t)

;; (load "/home/jmsb/.emacs.d/custom/lib/backup-dir.el")
;; (require 'backup-dir)
;; (make-variable-buffer-local 'backup-inhibited)
;; (setq bkup-backup-directory-info
;;       `((t ,live-backups-dir ok-create full-path prepend-name)))

(setq auto-save-file-name-transforms `((".*" ,(concat live-autosaves-dir "\\1") t)))
(setq backup-by-copying t)
(setq backup-directory-alist `((".*" . ,live-backups-dir)))
(setq auto-save-list-file-name (concat live-autosaves-dir "autosave-list"))

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
;; Ensure the exec-path honours the shell PATH
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Ignore .DS_Store files with ido mode
;; (add-to-list 'ido-ignore-files "\\.DS_Store")

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(add-to-list 'auto-mode-alist '("\\.fountain$" . fountain-mode))

(global-set-key (kbd "C-x g") 'magit-status)
