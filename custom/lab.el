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
