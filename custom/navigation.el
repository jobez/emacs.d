;; (require 'helm)
;; (require 'helm-config)
(helm-projectile-on)



;; (global-set-key (kbd "M-x") 'helm-M-x)

;; ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
;; (global-set-key (kbd "C-c h") 'helm-command-prefix)
;; (global-unset-key (kbd "C-x c"))

;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;; (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; (when (executable-find "curl")
;;   (setq helm-google-suggest-use-curl-p t))

;; (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
;;       helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
;;       helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
;;       helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
;;       helm-ff-file-name-history-use-recentf t)

;; (helm-autoresize-mode 1)

;; (helm-mode 1)

;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (global-set-key (kbd "C-x b") 'helm-mini)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)

;; (setq helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window

;;       helm-echo-input-in-header-line t) ;; input close to where I type

;; ;; (defun spacemacs//helm-hide-minibuffer-maybe ()
;; ;;   "Hide minibuffer in Helm session if we use the header line as input field."
;; ;;   (when (with-helm-buffer helm-echo-input-in-header-line)
;; ;;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
;; ;;       (overlay-put ov 'window (selected-window))
;; ;;       (overlay-put ov 'face
;; ;;                    (let ((bg-color (face-background 'default nil)))
;; ;;                      `(:background ,bg-color :foreground ,bg-color)))
;; ;;       (setq-local cursor-type nil))))

;; ;; (add-hook 'helm-minibuffer-set-up-hook
;; ;;       'spacemacs//helm-hide-minibuffer-maybe)

;; (setq helm-autoresize-max-height 0)
;; (setq helm-autoresize-min-height 20)


;; (setq helm-M-x-fuzzy-match nil
;;       helm-buffers-fuzzy-matching nil
;;       helm-recentf-fuzzy-match nil)

;; ;; (require 'helm-descbinds)
;; ;; (helm-descbinds-mode)
(use-package ivy :ensure t
  :diminish (ivy-mode . "")
  :bind
  (:map ivy-mode-map
        ("C-'" . ivy-avy)
        ("C-s" . swiper)
        ("M-x" . counsel-M-x)
        ("M-y" . counsel-yank-pop)
        ("C-x C-f" . counsel-find-file)
        ("<f1> f" . counsel-describe-function)
        ("<f1> v" . counsel-describe-variable)
        ("<f1> l" . counsel-find-library)
        ("<f2> i" . counsel-info-lookup-symbol)
        ("<f2> u" . counsel-unicode-char))
  :config
  (ivy-mode 1)
  (require 'projectile)
  (projectile-global-mode)
  (counsel-projectile-mode)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; number of result lines to display
  (setq ivy-height 12)
  ;; does not count candidates
  (setq ivy-count-format "")
  (setq ivy-display-style 'fancy)
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))


(setq magit-completing-read-function 'ivy-completing-read)
