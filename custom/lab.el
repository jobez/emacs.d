;; tentative configs
(define-key paredit-mode-map (kbd "s-\\") 'delete-indentation)

(add-to-list 'load-path "/nix/store/a9hx1clz9q421g173qf9djh762wmaq0m-emacs-libvterm-unstable-2019-07-22/share/emacs/site-lisp/")

(use-package vterm)


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
(global-set-key (kbd "M-l") (lambda () (interactive) (insert (make-char 'greek-iso8859-7 107))))


;;;; * key stuff
(setq ns-function-modifier 'hyper)
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)



(add-hook 'scheme-mode-hook 'geiser-mode)
(setq geiser-default-implementation 'racket)

;;key stuff
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-/") 'avy-pop-mark)
(global-set-key (kbd "s-,") 'ace-window)


(setq aw-dispatch-always t)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;; (require 'tramp)

;; (setq tramp-bkup-backup-directory-info bkup-backup-directory-info)

;; (setq tramp-backup-directory-alist backup-directory-alist)

(defun comint-clear-buffer ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(eval-after-load "comint"
  '(define-key comint-mode-map "\C-c\M-o" #'comint-clear-buffer))

;; (setq geiser-guile-load-path '("." "/home/jmsb/exps/mlearn/atomspace/build/release/share/opencog/scm" "/home/jmsb/exps/mlearn/atomspace/build/release/include/opencog/guile"))

;; (setq geiser-guile-load-init-file-p t)
;; (setq geiser-guile-binary '("guile"))

;; (eval-after-load "geiser-impl"
;;   '(add-to-list 'geiser-implementations-alist
;;                 '((dir "/home/jmsb/exps/mlearn/atomspace") guile)))

;; (setq load-path (append (list "/nix/store/1aqpgv118bhylq8b8q92wy5nvzi4dmzz-lilypond-2.18.2/share/emacs/site-lisp") load-path))
;; (autoload 'LilyPond-mode "lilypond-mode")
;; (setq auto-mode-alist
;;       (cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))

;; (when (window-system)
;;   (set-default-font "Fira Code"))

;; (let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
;;                (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
;;                (36 . ".\\(?:>\\)")
;;                (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
;;                (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
;;                (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
;;                (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
;;                (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;;                (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
;;                (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
;;                (48 . ".\\(?:x[a-zA-Z]\\)")
;;                (58 . ".\\(?:::\\|[:=]\\)")
;;                (59 . ".\\(?:;;\\|;\\)")
;;                (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
;;                (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
;;                (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;;                (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
;;                (91 . ".\\(?:]\\)")
;;                (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;;                (94 . ".\\(?:=\\)")
;;                (119 . ".\\(?:ww\\)")
;;                (123 . ".\\(?:-\\)")
;;                (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
;;                (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
;;                )
;;              ))
;;   (dolist (char-regexp alist)
;;     (set-char-table-range composition-function-table (car char-regexp)
;;                           `([,(cdr char-regexp) 0 font-shape-gstring]))))




(eval-after-load 'autoinsert
  '(define-auto-insert '("\\.cc.lisp\\'" . "C skeleton")
     '(> \n
       (format "%s" '(use-package :cm-ifs))
       > \n \n
       (format "%s" `(with-interface
                      (,(file-name-sans-extension
                         (file-name-sans-extension (file-name-nondirectory (buffer-file-name))))))))))


(setq user-full-name "Johann Makram Salib Bestowrous"
      user-mail-address "johann.bestowrous@gmail.com")


(use-package highlight-symbol
  :bind (("M-p" . highlight-symbol-prev)
         ("M-n" . highlight-symbol-next)
         ("M-'" . highlight-symbol-query-replace))
  :init
  (defun highlight-symbol-first ()
    "Jump to the first location of symbol at point."
    (interactive)
    (push-mark)
    (eval
     `(progn
        (goto-char (point-min))
        (search-forward-regexp
         (rx symbol-start ,(thing-at-point 'symbol) symbol-end)
         nil t)
        (beginning-of-thing 'symbol))))

  (defun highlight-symbol-last ()
    "Jump to the last location of symbol at point."
    (interactive)
    (push-mark)
    (eval
     `(progn
        (goto-char (point-max))
        (search-backward-regexp
         (rx symbol-start ,(thing-at-point 'symbol) symbol-end)
         nil t))))

  (bind-keys ("M-P" . highlight-symbol-first)
             ("M-N" . highlight-symbol-last)))

(add-to-list 'load-path "~/exps/langs/lisp/clojure/scratch/exo/orgexploration/src/elisp")

(require 'orgexploration)
