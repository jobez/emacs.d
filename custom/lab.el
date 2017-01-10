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



;;key stuff
(setq ns-function-modifier 'hyper)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-p") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(require 'epa-file)

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

(set-register ?m (cons 'file "~/orgs/main.org"))
(setq org-default-notes-file "~/orgs/main.org")
(setq geiser-guile-load-path '("." "/home/jmsb/exps/mlearn/atomspace/build/release/share/opencog/scm" "/home/jmsb/exps/mlearn/atomspace/build/release/include/opencog/guile"))

(setq geiser-guile-load-init-file-p t)
(setq geiser-guile-binary '("guile"))

(eval-after-load "geiser-impl"
  '(add-to-list 'geiser-implementations-alist
                '((dir "/home/jmsb/exps/mlearn/atomspace") guile)))

(setq load-path (append (list "/nix/store/1aqpgv118bhylq8b8q92wy5nvzi4dmzz-lilypond-2.18.2/share/emacs/site-lisp") load-path))
(autoload 'LilyPond-mode "lilypond-mode")
(setq auto-mode-alist
(cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))
