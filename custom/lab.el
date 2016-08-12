;; tentative configs

(define-key paredit-mode-map (kbd "s-\\") 'delete-indentation)

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(global-set-key (kbd "s-z") 'eval-and-replace)
(global-set-key (kbd "C-M-,") 'helm-occur)

(require 'helm-descbinds)
(helm-descbinds-mode)

;;key stuff
(setq ns-function-modifier 'hyper)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-p") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(require 'epa-file)

(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun eshell-brace-expansion (str)
  (let* ((parts (split-string str "[{}]"))
         (prefix (car parts))
         (body   (nth 1 parts))
         (suffix (nth 2 parts)))
    (mapcar (lambda (x) (concat prefix x suffix))
            (split-string body ","))))

(add-hook 'scheme-mode-hook 'geiser-mode)
(setq geiser-default-implementation 'racket)

;;key stuff
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-,") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))


(setq tramp-bkup-backup-directory-info bkup-backup-directory-info)

(setq tramp-backup-directory-alist backup-directory-alist)

(defun comint-clear-buffer ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))


(eval-after-load "comint"
  '(define-key comint-mode-map "\C-c\M-o" #'comint-clear-buffer))

;;(require 'edit-server)
;;(edit-server-start)
