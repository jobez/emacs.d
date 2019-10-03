(require 'ob-clojure)
;; (require 'ob-clojurescrip t)
(require 'ob-lisp)
(require 'ob-dot)
(require 'cider)

(require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive)

(setq org-id-locations-file "~/orgs/structure/.org-id-locations")

;; Update ID file on startup
(org-id-update-id-locations)

(setq org-ellipsis "⤵")

(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)


(use-package org-mind-map
  :init
  (require 'ox-org)
  :ensure t
  ;; Uncomment the below if 'ensure-system-packages` is installed
  ;;:ensure-system-package (gvgen . graphviz)
  :config
  (setq org-mind-map-engine "dot")       ; Default. Directed Graph
  ;; (setq org-mind-map-engine "neato")  ; Undirected Spring Graph
  ;; (setq org-mind-map-engine "twopi")  ; Radial Layout
  ;; (setq org-mind-map-engine "fdp")    ; Undirected Spring Force-Directed
  ;; (setq org-mind-map-engine "sfdp")   ; Multiscale version of fdp for the layout of large graphs
  ;; (setq org-mind-map-engine "twopi")  ; Radial layouts
  ;; (setq org-mind-map-engine "circo")  ; Circular Layout
  (setq org-mind-map-default-graph-attribs (cl-pushnew '("fontsize" . "24") org-mind-map-default-graph-attribs))
  )

(use-package org-brain :ensure t
  :init
  (setq org-brain-path "~/orgs/structure/brain")
  ;; For Evil users
  ;; (with-eval-after-load 'evil
  ;;   (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (setq org-id-track-globally t)

  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (clojure . t)
   ;; (clojurescript . t)
   (picolisp . t)
   (dot . t)
   (go . t)
   (scheme . t)
   (ruby . t)
   (calc . t)
   (ocaml . t)
   (python . t)
   (haskell . t)
   (lisp . t)
   (ditaa . t)
   (perl . t)
   ;; (c . t)
   (prolog . t)
   (gnuplot t)))



(require 'ob-async)
;; (add-to-list 'org-ctrl-c-ctrl-c-hook 'ob-async-org-babel-execute-src-block)

;; Show syntax highlighting per language native mode in *.org
(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)
;; For languages with significant whitespace like Python:
(setq org-src-preserve-indentation t)
(setq org-babel-clojure-backend 'cider)
(setq org-babel-lisp-backend 'slime)

(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("bjmarticle"
               "\\documentclass{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{hyperref}
\\usepackage{natbib}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage{geometry}
\\geometry{a4paper,left=2.5cm,top=2cm,right=2.5cm,bottom=2cm,marginparsep=7pt, marginparwidth=.6in}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))



;; TODO: need one more join--moving structured subtrees to/from research repos
(setq org-refile-targets (list  '(nil :maxlevel . 9)
                                '("~/orgs/structure/melody.org" :maxlevel . 9)
                                '("~/orgs/structure/repo.org" :maxlevel . 9)
                                '("~/orgs/structure/harmony.org" :maxlevel . 9)
                                '("~/orgs/surfacings/pieces.org" :maxlevel . 9)
                                '("~/orgs/surfacings/blog/blog.org" :maxlevel . 9)
                                ;; '("~/orgs/surfacings/captainslog.org" :maxlevel . 9)
                                ))

(setf org-format-latex-options
      '(:foreground default :background default :scale 4.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                   ("begin" "$1" "$" "$$" "\\(" "\\[")))



; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes  'confirm)

(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
(setq org-refile-use-outline-path t)                  ; Show full paths for refiling


(setq org-ditaa-jar-path "/nix/store/axh85y67ckjfyc4pkgp1h3iwkiw1hbvs-ditaa-0.11.0/lib/ditaa.jar")

(set-register ?m (cons 'file "~/orgs/structure/refile.org"))
(setq org-default-notes-file "~/orgs/structure/refile.org")

(setq org-agenda-files '(
                        "~/orgs/structure/refile.org"
                        "~/orgs/structure/repo.org"
                        "~/orgs/surfacings/pieces.org"
                        ;; "~/orgs/structure/melody.org"
                        ;; "~/orgs/structure/harmony.org"
                        ;; "~/orgs/surfacings/blog/blog.org"
                        ))

(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n"))))

(setq org-capture-templates
      '(("!" "Riffs" entry (file+olp+datetree "~/orgs/structure/refile.org" )
          "* %?\nEntered on %U\n  %i\n  %a")
        ("g" "Daily Goals" entry (file+olp+datetree "~/orgs/surfacings/captainslog.org" "Daily Goals")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("r" "Recap" entry (file+olp+datetree "~/orgs/surfacings/captainslog.org" "Recaps")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("h"                ;`org-capture' binding + h
         "post"
         entry
         (file+olp "~/orgs/surfacings/blog/blog.org" "Drafts")
         (function org-hugo-new-subtree-post-capture-template))))

(setq org-agenda-custom-commands
      '(("f" occur-tree "FIXME")))

(defun kiss-org-parse ()
  (interactive)
  (let* ((tree (org-element-parse-buffer 'object nil)))
    (org-element-map tree (append org-element-all-elements
                                  org-element-all-objects '(plain-text))
      (lambda (x)
        (if (org-element-property :parent x)
            (org-element-put-property x :parent "none"))
        (if (org-element-property :structure x)
            (org-element-put-property x :structure "none"))))
    (slime-eval `(kiss::orgsexp->slides ',tree 5))))





(define-key global-map "\C-ck" 'kiss-org-parse)

(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)


;; (defvar count-words-buffer
;;   nil
;;   "*Number of words in the buffer.")

;; (defvar *wc-timer*)

;; (defun wicked/update-wc ()
;;   (interactive)
;;   (setq count-words-buffer (number-to-string (count-words-buffer)))
;;   (force-mode-line-update))

;; ; only setup timer once
;; (unless count-words-buffer
;;   ;; seed count-words-paragraph
;;   ;; create timer to keep count-words-paragraph updated
;;   (run-with-idle-timer 1 t 'wicked/update-wc))

;; ;; add count words paragraph the mode line
;; (unless (memq 'count-words-buffer global-mode-string)
;;   (add-to-list 'global-mode-string "words: " t)
;;   (add-to-list 'global-mode-string 'count-words-buffer t))

;; ;; count number of words in current paragraph
;; (defun count-words-buffer ()
;;   "Count the number of words in the current paragraph."
;;   (interactive)
;;   ;; (save-excursion
;;   ;;   (goto-char (point-min))
;;   ;;   (let ((count 0))
;;   ;;     (while (not (eobp))
;; 	;; (forward-word 1)
;;   ;;       (setq count (1+ count)))
;;   ;;     count))
;;   1)

;; don't really use this
(setq org-todo-keywords
      '((sequence "TODO(t!)"  "NEXT(n!)" "|" "DONE(d!)")
        (sequence "PROCESS-INTO-CARDS" "|" "PROCESSED-INTO-CARDS)"
                  ;; (sequence "REPEAT(r)"  "WAIT(w!)"  "|"  "PAUSED(p@/!)" "CANCELLED(c@/!)" )
       ;; (sequence "IDEA(i!)" "MAYBE(y!)" "STAGED(s!)" "WORKING(k!)" "|" "USED(u!/@)")
       )))

(when (version<= "9.2" (org-version))
    (require 'org-tempo))

(eval-after-load 'org '(require 'org-pdfview))

(require 'org-drill)

(define-key org-mode-map "\C-c\C-xw" 'org-wc-display)

(defun word-count-analysis (start end)
      "Count how many times each word is used in the region.
    Punctuation is ignored."
      (interactive "r")
      (let (words)
	(save-excursion
	  (goto-char start)
	  (while (re-search-forward "\\w+" end t)
	    (let* ((word (intern (match-string 0)))
		   (cell (assq word words)))
	      (if cell
		  (setcdr cell (1+ (cdr cell)))
		(setq words (cons (cons word 1) words))))))
	(when (interactive-p)
	  (message "%S" words))
	words))
