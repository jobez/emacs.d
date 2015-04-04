(defvar swap-paren-pairs '("()" "[]" "{}"))
(defun swap-parens-at-points (b e)
  (let ((open-char (buffer-substring b (+ b 1)))
        (paren-pair-list (append swap-paren-pairs swap-paren-pairs)))
    (while paren-pair-list
      (if (eq (aref open-char 0) (aref (car paren-pair-list) 0))
          (save-excursion
            (setq to-replace (cadr paren-pair-list))
            (goto-char b)
            (delete-char 1)
            (insert (aref to-replace 0))
            (goto-char (- e 1))
            (delete-char 1)
            (insert (aref to-replace 1))
            (setq paren-pair-list nil))
        (setq paren-pair-list (cdr paren-pair-list))))))

(defun swap-parens ()
  (interactive)
  (cond ((looking-at "\\s(")
         (swap-parens-at-points (point) (save-excursion (forward-sexp) (point))))
        ((and (> (point) 1) (save-excursion (forward-char -1) (looking-at "\\s)")))
         (swap-parens-at-points (save-excursion (forward-sexp -1) (point)) (point)))
        ((message "Not at a paren"))))

;; narrowing

(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies
first.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(winner-mode 1)
(windmove-default-keybindings)
(setq org-replace-disputed-keys t)

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key [?\s-w] 'kill-current-buffer)

(defun cider-eval-expression-at-point-in-repl ()
  (interactive)
  (let ((form (cider-sexp-at-point)))
    ;; Strip excess whitespace
    (while (string-match "\\`\s+\\|\n+\\'" form)
      (setq form (replace-match "" t t form)))
    (set-buffer (cider-find-or-create-repl-buffer))
    (goto-char (point-max))
    (insert form)
    (cider-repl-return)))

(defun split-window-vertical (&optional number)
  "Split the current window into `number' windows"
  (interactive "P")
  (setq number (if number
                   (prefix-numeric-value number)
                 2))
  (while (> number 1)
    (split-window-right)
    (setq number (- number 1)))
  (balance-windows))

(global-set-key (kbd "C-x C-3") 'split-window-vertical)

;; Default Emacs Live bindings


;; C-c Groups
;;
;;e - eval and replace
;;b - winner undo
;;f - winner redo
;;g - git gutter
;;l - lispy shortcuts (i.e. paredit and clojure specific fns)
;;m - emacs eval shortcuts
;;t - text shortcuts
;;i - utf8 char shortcuts
;;j - quick-jump shortcuts
;;d - diff shortcuts
;;p - project shortcuts
;;s - show popupwindows
;;w - window and buffer shortcuts


;; Should be able to eval-and-replace anywhere.
(global-set-key (kbd "C-c e") 'eval-and-replace)

;; winner undo and redo
(global-set-key (kbd "C-c b") 'winner-undo)
(global-set-key (kbd "C-c f") 'winner-redo)

;; Git Gutter
(global-set-key (kbd "C-c g g") 'git-gutter:toggle)

;; Jump to next/previous diff
(global-set-key (kbd "C-c g p") 'git-gutter:previous-diff)
(global-set-key (kbd "C-c g n") 'git-gutter:next-diff)
(global-set-key (kbd "C-c g d") 'git-gutter:popup-diff)
(global-set-key (kbd "C-c g r") 'git-gutter:revert-hunk)

;;text manipulation shortcuts
(global-set-key (kbd "C-c t b") 'untabify-buffer)
(global-set-key (kbd "C-c t r") 'untabify)

;;emacs-lisp shortcuts
(global-set-key (kbd "C-c m s") 'eval-and-replace) ;swap
(global-set-key (kbd "C-c m b") 'eval-buffer)
(global-set-key (kbd "C-c m e") 'eval-last-sexp)
(global-set-key (kbd "C-c m i") 'eval-expression)
(global-set-key (kbd "C-c m d") 'eval-defun)
(global-set-key (kbd "C-c m n") 'eval-print-last-sexp)
(global-set-key (kbd "C-c m r") 'eval-region)

(global-set-key (kbd "C-c n e b") 'cider-eval-buffer)


;;funky characters
(global-set-key (kbd "C-c i l") (lambda () (interactive) (insert "λ")))
(global-set-key (kbd "C-c i n") (lambda () (interactive) (insert "ℕ")))
(global-set-key (kbd "C-c i i") (lambda () (interactive) (insert "∞")))
(global-set-key (kbd "C-c i .") (lambda () (interactive) (insert "×")))
(global-set-key (kbd "C-c i 0") (lambda () (interactive) (insert "∅")))
(global-set-key (kbd "C-c i u") (lambda () (interactive) (insert "∪")))
(global-set-key (kbd "C-c i s") (lambda () (interactive) (insert "♯")))
(global-set-key (kbd "C-c i f") (lambda () (interactive) (insert "♭")))
(global-set-key (kbd "C-c i p") (lambda () (interactive) (insert "£")))

(global-set-key (kbd "C-c j p") 'quick-jump-go-back)
(global-set-key (kbd "C-c j b") 'quick-jump-go-back)
(global-set-key (kbd "C-c j m") 'quick-jump-push-marker)
(global-set-key (kbd "C-c j n") 'quick-jump-go-forward)
(global-set-key (kbd "C-c j f") 'quick-jump-go-forward)
(global-set-key (kbd "C-c j c") 'quick-jump-clear-all-marker)

;;diff shortcuts
(global-set-key (kbd "C-c d f") 'diff-buffer-with-file)

;;window and buffer movement
(global-set-key (kbd "C-c w s") 'swap-windows)
(global-set-key (kbd "C-c w r") 'rotate-windows)
(global-set-key (kbd "C-c w p") 'buf-move-up)
(global-set-key (kbd "C-c w n") 'buf-move-down)
(global-set-key (kbd "C-c w b") 'buf-move-left)
(global-set-key (kbd "C-c w f") 'buf-move-right)
(global-set-key (kbd "C-c w .") 'shrink-window-horizontally)
(global-set-key (kbd "C-c w ,") 'enlarge-window-horizontally)
(global-set-key (kbd "C-c w /") (lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "C-c w '") (lambda () (interactive) (enlarge-window 1)))

;; clojure

(define-key clojure-mode-map (kbd "C-c l l") 'align-cljlet)
(define-key clojure-mode-map (kbd "C-M-z")   'align-cljlet)

(define-key paredit-mode-map (kbd "C-c l k") 'paredit-splice-sexp-killing-forward)
(define-key paredit-mode-map (kbd "C-c l w") 'paredit-splice-sexp-killing-backward)
(define-key paredit-mode-map (kbd "C-c l l") 'align-cljlet)
(define-key paredit-mode-map (kbd "C-c l t") 'fill-paragraph)
(define-key paredit-mode-map (kbd "C-c l j") 'live-paredit-forward-slurp-sexp-neatly)
(define-key paredit-mode-map (kbd "C-M-e")   'paredit-backward-barf-sexp)
(define-key paredit-mode-map (kbd "C-M-s")   'paredit-backward-slurp-sexp)
(define-key paredit-mode-map (kbd "C-M-j")   'live-paredit-forward-slurp-sexp-neatly)
(define-key paredit-mode-map (kbd "C-M-y")   'paredit-forward-barf-sexp)
(define-key paredit-mode-map (kbd "C-M-z")   'align-cljlet)
(define-key paredit-mode-map (kbd "M-S")     'paredit-split-sexp)
(define-key paredit-mode-map (kbd "M-s")     'paredit-splice-sexp)
(define-key paredit-mode-map (kbd "M-j")     'paredit-join-sexps)
(define-key paredit-mode-map (kbd "M-P")     'live-paredit-previous-top-level-form)
(define-key paredit-mode-map (kbd "M-N")     'live-paredit-next-top-level-form)
(define-key paredit-mode-map (kbd "C-M-f")   'live-paredit-forward)
(define-key paredit-mode-map (kbd "M-q")     'live-paredit-reindent-defun)
(define-key paredit-mode-map (kbd "M-d")     'live-paredit-forward-kill-sexp)
(define-key paredit-mode-map (kbd "M-k")     'live-paredit-backward-kill)
(define-key paredit-mode-map (kbd "M-\\")    'live-paredit-delete-horizontal-space)
(define-key paredit-mode-map (kbd "C-M-i")   'paredit-forward-down)
(define-key paredit-mode-map (kbd "C-M-n")   'paredit-forward-up)
(define-key paredit-mode-map (kbd "C-M-p")   'paredit-backward-down)
(define-key paredit-mode-map (kbd "C-M-u")   'paredit-backward-up)
(define-key paredit-mode-map (kbd "M-T")     'transpose-sexps)
(define-key paredit-mode-map (kbd "C-M-k")   'live-paredit-copy-sexp-at-point)

;; org-mode
(define-key org-mode-map (kbd "C-M-f")    'org-metadown)
(define-key org-mode-map (kbd "C-M-b")    'org-metaup)
(define-key org-mode-map (kbd "C-M-l")    'org-shiftright)
(define-key org-mode-map (kbd "C-M-j")    'org-shiftleft)
(define-key org-mode-map (kbd "C-M-i")    'org-shiftup)
(define-key org-mode-map (kbd "C-M-k")    'org-shiftdown)
(define-key org-mode-map (kbd "C-M-_")    'live-decrement-number-at-point)

;;increment and decrement number at point
(global-set-key (kbd "C-M-_")  'live-decrement-number-at-point)
(global-set-key (kbd "M-=")    'live-increment-number-at-point)
(global-set-key (kbd "C-M-=")    'live-increment-number-at-point)


;;browse kill ring (visual paste)
(global-set-key (kbd "M-y") 'browse-kill-ring)

;;make C-] and M-] cut and copy respectively
(global-set-key (kbd "C-]") 'kill-region)
(global-set-key (kbd "M-]") 'kill-ring-save)

;; undo
(global-set-key (kbd "C-M-_") 'undo-tree-undo)
(global-set-key (kbd "C-_")   'undo-tree-undo)

;;mark current function
(global-set-key (kbd "C-x C-p") 'mark-defun)

;;use delete-horizontal-space to completely nuke all whitespace
(global-set-key (kbd "M-SPC ") 'live-delete-whitespace-except-one)

;;redefine help shortcut
(global-set-key (kbd "M-h") 'help-command)
(define-key org-mode-map (kbd "M-h") 'help-command)

;;allow the deletion of words:
;;backward kill word (forward kill word is M-d)
(global-set-key (kbd "C-\\") 'backward-kill-word)
(define-key ido-file-completion-map (kbd "C-\\") 'backward-kill-word)
(define-key paredit-mode-map (kbd "C-\\") 'paredit-backward-kill-word)

;;kill line backwards
(global-set-key (kbd "M-k") 'live-backwards-kill-line)

;;kill regions
(global-set-key (kbd "C-x C-k") 'kill-region)

;;set the mark
(global-set-key (kbd "C-SPC") 'set-mark-command)

;;repeat previous command
(global-set-key (kbd "M-'") 'repeat)

;;scroll other window
(global-set-key (kbd "C-M-]") 'scroll-other-window)
(global-set-key (kbd "C-M-[") 'scroll-other-window-down)



;;fast vertical naviation
(global-set-key  (kbd "M-U") (lambda () (interactive) (forward-line -10)))
(global-set-key  (kbd "M-D") (lambda () (interactive) (forward-line 10)))
(global-set-key  (kbd "M-p") 'outline-previous-visible-heading)
(global-set-key  (kbd "M-n") 'outline-next-visible-heading)

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; comment region
(global-set-key (kbd "M-/") 'comment-or-uncomment-region)

(global-set-key (kbd "C-s")   'isearch-forward)
(global-set-key (kbd "C-r")   'isearch-backward)
(global-set-key (kbd "C-M-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-r") 'isearch-backward-regexp)

;; Jump to a definition in the current file.
(global-set-key (kbd "C-x C-i") 'idomenu)

;; File
(global-set-key (kbd "C-x M-f")   'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f")     'live-recentf-ido-find-file)
(global-set-key (kbd "C-x C-r")   'ido-recentf-open)
(global-set-key (kbd "M-`")       'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b")   'ibuffer)

;; If you want to be able to M-x without meta
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

;; Show documentation/information with M-RET
(define-key lisp-mode-shared-map (kbd "M-RET") 'live-lisp-describe-thing-at-point)
;;(define-key cider-repl-mode-map (kbd "M-RET") 'cider-doc)
;;(define-key cider-mode-map (kbd "M-RET") 'cider-doc)

(global-set-key (kbd "C-x o") 'win-switch-dispatch)

(global-set-key (kbd "C-x !") 'live-server-kill-terminal)

;; =========== Personal Bindings ==========

(global-set-key (kbd "C-x C-o") 'ffip)
(global-set-key (kbd "C-x C-g") 'ag)

;; bookmarks
(global-set-key (kbd "C-c M-t") 'bm-toggle)
(global-set-key (kbd "C-c M-n") 'bm-next)
(global-set-key (kbd "C-c M-p") 'bm-previous)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C-a") 'mc/mark-all-like-this-dwim)

(global-set-key (kbd "C-c [") 'swap-parens)

(global-set-key (kbd "C-c C-n") 'narrow-or-widen-dwim)

(global-set-key (kbd "C-`") 'cider-eval-expression-at-point-in-repl)

;; Ace jump mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
