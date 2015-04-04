;; appearance

(setq sml/no-confirm-load-theme t)
(load-theme 'zenburn t)
(require 'smart-mode-line)
(sml/setup)
(sml/apply-theme 'powerline)

(global-undo-tree-mode)
(set-frame-parameter nil 'unsplittable t)

;; (setq ns-auto-hide-menu-bar t)
(tool-bar-mode 0)
(global-visual-line-mode t)

;;(set-variable 'magit-emacsclient-executable "/usr/local/Cellar/emacs/HEAD/bin/emacsclient")

;; indentation

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq tab-width 2)
(setq c-basic-indent 2)
(setq c-basic-offset 2)
(setq js-indent-level 2)
(setq css-indent-level 2)
(setq css-indent-offset 2)

(setq js-indent-level 2)
(setq js2-always-indent-assigned-expr-in-decls-p t)
(setq js2-basic-offset 2)
(setq-default js2-basic-offset 2)
(setq js2-cleanup-whitespace t)
(setq js2-enter-indents-newline t)
(setq js2-highlight-external-variables nil)
(setq js2-indent-on-enter-key t)
(setq js2-mode-show-strict-warnings nil)
(setq js2-pretty-multiline-declarations (quote all))

;; autocomplete
(add-hook 'after-init-hook 'global-company-mode)

;; ffip
(setq ffip-limit 4096)
;; (setq ffip-patterns (append `("*.erb" "*.tpl" "*.php" "*.css" "*.ru" "*.json" "*.rb" "*.sass" "*.scss" "*.clj" "*.cljs") ffip-patterns))
(setq ffip-full-paths 1)

(ido-mode 1)
(ido-everywhere 1)
(ido-vertical-mode nil)
(flx-ido-mode 1)
(icomplete-mode 1)
(setq ido-enable-prefix nil
      ido-create-new-buffer 'always
      ido-max-prospects 10
      ido-default-file-method 'selected-window
      ido-everywhere 1)
;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)

                                        ;remove bells
(setq ring-bell-function 'ignore)

(defvar live-tmp-dir "~/.emacs.d/tmp/")
(defvar live-autosaves-dir "~/.emacs.d/autosaves/")
(defvar live-backups-dir "~/.emacs.d/backups/")

;;store history of recently opened files
(require 'recentf)
(setq recentf-save-file (concat live-tmp-dir "recentf")
      recentf-max-saved-items 200)
(recentf-mode t)

;;When you visit a file, point goes to the last place where it was
;;when you previously visited. Save file is set to live-tmp-dir/places
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat live-tmp-dir "places"))

;;enable winner mode for C-c-(<left>|<right>) to navigate the history
;;of buffer changes i.e. undo a split screen
(when (fboundp 'winner-mode)
  (winner-mode 1))

(setq initial-major-mode 'lisp-interaction-mode
      redisplay-dont-pause t
      column-number-mode t
      echo-keystrokes 0.02
      inhibit-startup-message t
      transient-mark-mode t
      shift-select-mode nil
      require-final-newline t
      truncate-partial-width-windows nil
      delete-by-moving-to-trash nil
      confirm-nonexistent-file-or-buffer nil
      query-replace-highlight t
      next-error-highlight t
      next-error-highlight-no-select t)

;;set all coding systems to utf-8
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
;;disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(setq utf-translate-cjk-mode nil)

(set-default 'indent-tabs-mode nil)
(auto-compression-mode t)
(show-paren-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

;;default to unified diffs
(setq diff-switches "-u"
      ediff-window-setup-function 'ediff-setup-windows-plain)

;; make emacs use the clipboard
(setq x-select-enable-clipboard t)

;;remove all trailing whitespace and trailing blank lines before
;;saving the file
(defvar live-ignore-whitespace-modes '(markdown-mode))
(defun live-cleanup-whitespace ()
  (if (not (member major-mode live-ignore-whitespace-modes))
      (let ((whitespace-style '(trailing empty)) )
        (whitespace-cleanup))))

(add-hook 'before-save-hook 'live-cleanup-whitespace)

;; savehist keeps track of some history
(setq savehist-additional-variables
      ;; search entries
      '(search ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (concat live-tmp-dir "savehist"))
(savehist-mode t)

(load "backup-dir.el")
(require 'backup-dir)
(make-variable-buffer-local 'backup-inhibited)
(setq bkup-backup-directory-info
      `((t ,live-backups-dir ok-create full-path prepend-name)))

(setq auto-save-file-name-transforms `((".*" ,(concat live-autosaves-dir "\\1") t)))
(setq backup-by-copying t)
(setq backup-directory-alist `((".*" . ,live-backups-dir)))
(setq auto-save-list-file-name (concat live-autosaves-dir "autosave-list"))

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; OS X specific configuration
;; ---------------------------

(setq default-input-method "MacOSX")

;; Make cut and paste work with the OS X clipboard

(defun live-copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun live-paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(when (not window-system)
  (setq interprogram-cut-function 'live-paste-to-osx)
  (setq interprogram-paste-function 'live-copy-from-osx))

;; Work around a bug on OS X where system-name is a fully qualified
;; domain name
(setq system-name (car (split-string system-name "\\.")))

;; Ensure the exec-path honours the shell PATH
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Ignore .DS_Store files with ido mode
(add-to-list 'ido-ignore-files "\\.DS_Store")

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


(defun live-delete-whitespace-except-one ()
  (interactive)
  (just-one-space -1))


(defun live-backwards-kill-line ()
  "Kill all characters on current line before point. Same as
  passing 0 as an argument to kill-line"
  (interactive)
  (kill-line 0))

(defun live-end-of-buffer-p ()
  "Predicate fn to determine whether point is at the end of the
   buffer"
  (<= (buffer-size) (point)))

(defun live-indent-defun ()
  "Indent the current defun."
  (interactive)
  (save-excursion
    (mark-defun)
    (indent-region (region-beginning) (region-end))))

(defun live-delete-and-extract-sexp ()
  "Delete the sexp and return it."
  (interactive)
  (let* ((begin (point)))
    (forward-sexp)
    (let* ((result (buffer-substring-no-properties begin (point))))
      (delete-region begin (point))
      result)))
