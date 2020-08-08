;; (add-to-list 'load-path "~/exps/emacs/org-mode")
(require 'org)
(require 'ob-clojure)
;; (require 'ob-clojurescrip t)
(require 'ob-lisp)
(require 'ob-dot)
;; (require 'cider)

(require 'org-id)
(setq org-id-link-to-org-use-id 'create-if-interactive)

(setq org-id-locations-file "~/orgs/structure/.org-id-locations")

;; Update ID file on startup
(setq org-id-extra-files '("~/orgs/structure/cards.org"
                           "~/orgs/structure/melody.org"))

(setq  org-agenda-files '(
                         "~/orgs/structure/theoria.org"
                         "~/orgs/structure/praxis.org"
                         "~/orgs/structure/refile.org"
                        "~/orgs/structure/repo.org"
                        "~/orgs/surfacings/pieces.org"
                        "~/orgs/structure/journal/2020"
                        "~/orgs/structure/lectica"

                        ;; "~/orgs/structure/harmony.org"
                        ;; "~/orgs/surfacings/blog/blog.org"
                        ))

(org-id-update-id-locations)

;; (setq org-ellipsis "⤵")

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

  ;; (push '("b" "Brain" plain (function org-brain-goto-end)
  ;;         "* %i%?" :empty-lines 1)
  ;;       org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

(add-to-list 'org-src-lang-modes '("jupyter" . python))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (clojure . t)
   ;; (clojurescript . t)
   (picolisp . t)
   (dot . t)
   ;; (go . t)
   (scheme . t)
   (ruby . t)
   (calc . t)
   (ocaml . t)
   (python . t)
   (haskell . t)
   (lisp . t)
   (ditaa . t)
   (perl . t)
   ;; (sparql . t)
   ;; (prolog . t)
   (gnuplot . t)
   (latex . t)
   ))

(add-to-list 'org-src-lang-modes '("jupyter" . python))



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

(defun jhnn-foo-template ()
  (with-temp-buffer
    (org-mode)
    (insert "* %?")
    (newline)
    (call-interactively #'jhnn-org-query-backlink)
    (newline)
    (insert "Entered on %U")
    (newline)
    (insert "%a")
    (buffer-string)))

(setq org-capture-templates
      '(
        ("!" "Journal" entry (file+olp+datetree "~/orgs/structure/journal/2020/journal.org" )
         ;; "* %(jhnn-org-query-backlink)  %?\nEntered on %U\n  %i\n  %a"
         (function jhnn-foo-template))
        ("e" "todays entry in this weeks eleutherios" entry
         (file+olp+datetree "~/orgs/structure/journal/2020/eleutheri.org" )
         "* %?\nEntered on %U\n  %i\n  %a"
        :tree-type week) 
        ("r" "weekly retroflection" entry (file+olp+datetree "~/orgs/structure/journal/2020/retroflection.org" )
         "* %?\nEntered on %U\n  %i\n  %a"
         :tree-type week)
        ("g" "weekly goals" entry (file+olp+datetree "~/orgs/structure/journal/2020/goals.org" )
         "* %?\nEntered on %U\n  %i\n  %a"
         :tree-type week)
        ("f" "today's freewrite" entry (file+olp+datetree "~/orgs/structure/journal/2020/freewrites.org" )
         "* %?\nEntered on %U\n  %i\n  %a"
         :tree-type week)
        ("s" "structured narrative entry" entry (file+olp+datetree "~/orgs/structure/journal/2020/narratives.org" )
         (file "~/orgs/structure/writingtmpl.org")
         ;; "* %?\nEntered on %U\n  %i\n  %a"
         :tree-type week)
        ;; ("g" "Daily Goals" entry (file+olp+datetree "~/orgs/surfacings/captainslog.org" "Daily Goals")
        ;;  "* %?\nEntered on %U\n  %i\n  %a")
        ;; ("r" "Recap" entry (file+olp+datetree "~/orgs/surfacings/captainslog.org" "Recaps")
        ;;  "* %?\nEntered on %U\n  %i\n  %a")
        ;; ("h"                ;`org-capture' binding + h
        ;;  "post"
        ;;  entry
        ;;  (file+olp "~/orgs/surfacings/blog/blog.org" "Drafts")
        ;;  (function org-hugo-new-subtree-post-capture-template))
        ))


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


(defvar *transclude* t "Put overlays on or not")

(setq *transclude* t)

(use-package org-ql
  :quelpa (org-ql :fetcher github :repo "alphapapa/org-ql")
  :after org
  :config
  (require 'helm-org-ql)
  (defun eh-org-query ()
    (interactive)
    (ivy-read "Org query: " #'eh-org-query-collect
              :dynamic-collection t
              :initial-input (eh-org-query-string)
              :action #'eh-org-query-goto))

  (defun eh-org-query-picklink ()
    (interactive)
    (ivy-read "Org query: " #'eh-org-query-collect
              :dynamic-collection t
              :initial-input (eh-org-query-string)
              :action #'eh-org-query-insert-link))

  (defun jhnn-org-query-backlink ()
    (interactive)
    (ivy-read "Org query: " #'eh-org-query-collect
              :dynamic-collection t
              :initial-input (eh-org-query-string)
              :action #'jhnn-org-query-insert-backlink))

  (defun eh-org-query-string ()
    (when mark-active
      (buffer-substring-no-properties
       (region-beginning) (region-end))))

  (defvar eh-org-query-collect-timer nil)
  (defun eh-org-query-collect (input)
    (when eh-org-query-collect-timer
      (cancel-timer eh-org-query-collect-timer))
    (if (< (length input) 4)
        (list "" (format "%d chars more" (- 4 (length input))))
      (setq eh-org-query-collect-timer
            (run-with-timer
             0.25 nil
             `(lambda ()
                (let ((files (org-agenda-files))
                      (query (read ,input)))
                  (when query
                    (ignore-errors
                      (setq ivy--all-candidates
                            (or
                             (org-ql-select files query
                               :action (lambda ()
                                         (propertize (org-get-heading t)
                                                     'marker (copy-marker (point)))))
                             '("" "Search no results!")))
                      (setq ivy--old-cands ivy--all-candidates)
                      (ivy--exhibit)))))))
      nil))

  (defun eh-org-query-goto (headline)
    (interactive)
    (let ((marker (get-text-property 0 'marker headline)))
      (when (markerp marker)
        (switch-to-buffer (marker-buffer marker))
        (goto-char marker)
        (org-show-entry))))

  (defun eh-org-query-insert-link (headline &optional link-type breadcrumbs)
    (interactive)
    (let ((marker (get-text-property 0 'marker headline))
          store-link)
      (when (markerp marker)
        (org-with-point-at marker
          (let* ((id (org-id-get (point) t))
                 (attach-dir (org-attach-dir t))
                 (breadcrumbs
                  (when breadcrumbs
                    (let ((s (org-format-outline-path
                              (org-get-outline-path)
                              (1- (frame-width))
                              nil org-picklink-breadcrumbs-separator)))
                      (if (eq "" s) "" (concat s org-picklink-breadcrumbs-separator)))))
                 (item (concat (or breadcrumbs "") (org-entry-get (point) "ITEM")))
                 (link
                  (cl-case link-type
                    (attach (list :link attach-dir :description (concat item "(ATTACH)") :type "file"))
                    (t (list :link (concat "id:" id) :description item :type "id")))))
            (setq store-link link)))
        (org-insert-link nil (plist-get store-link :link) (plist-get store-link :description))
        (cond ((org-in-item-p)
               (call-interactively #'org-insert-item))
              (t (insert " "))))))

  (defun jhnn-org-query-insert-backlink (headline &optional link-type breadcrumbs)
    (interactive)
    (let ((marker (get-text-property 0 'marker headline))
          store-link)
      (when (markerp marker)
        (org-with-point-at marker
          (sl-store-link)))))

  
  )

(use-package bookmark+
  :quelpa (bookmark+ :fetcher github :repo "emacsmirror/bookmark-plus")
  :config
  (setq  bookmark-file "~/orgs/bookmark")
  (setq bookmark-save-flag 3))

(use-package org-super-links
  :quelpa (org-super-links :repo "toshism/org-super-links" :fetcher github :commit "0.2")
  :bind (("C-c C-l" . sl-store-link)
         ("C-c C-i" . sl-insert-link)
         ))


(org-link-set-parameters
 "transclude"
 :face '(:background "gray80")
 :follow (lambda (path)
           (org-open-link-from-string path))
 :keymap (let ((map (copy-keymap org-mouse-map)))
           (define-key map [C-mouse-1] (lambda ()
                                         (interactive)
                                         (setq *transclude* (not *transclude*))
                                         (unless *transclude*
                                           (ov-clear 'transclude))
                                         (font-lock-fontify-buffer)))
           map)
 :help-echo "Transcluded element. Click to open source. C-mouse-1 to toggle overlay."
 :activate-func (lambda (start end path bracketp)
                  (if *transclude*
                      (let ((ov (make-overlay start end))
                            el disp)
                        (ov-put ov 'transclude t)
                        (save-window-excursion
                          (org-open-link-from-string path)
                          (setq el (org-element-context))
                          (setq disp (buffer-substring
                                      (org-element-property :begin el)
                                      (- (org-element-property :end el)
                                         (or (org-element-property :post-blank el) 0))))
                          (ov-put ov 'display disp)))
                    (ov-clear 'transclude 'any start end))))

(org-link-set-parameters
 "smsn"
 :face '(:background "magenta")
 :follow (lambda (path)
           (smsn-client-open-note-as-org path)))

(defun id->cloned-narrow-subtree-occur (id occur-query)
  (-let* (((filename . lino)
           (org-id-find id)))
    ;; (with-current-buffer ()
    ;;    (org-narrow-to-subtree))
    (with-current-buffer
        (with-current-buffer (get-file-buffer filename)
          (clone-indirect-buffer nil t))
      (goto-char lino)
      (org-show-context)
      (org-narrow-to-element)
      (occur occur-query))))

(defun narrow-clone-at-id
    (clone-buffer-name id epigeal-pt)
 (-if-let* (((filename . lino)
             (org-id-find id)))
     (-let* ((file-buff (get-file-buffer filename))
             (clone-of-file-buffer
              (with-current-buffer
                  file-buff
                (clone-indirect-buffer
                 clone-buffer-name
                 nil))))
       (with-current-buffer clone-of-file-buffer
         (goto-char lino)
         (org-show-context)
         (org-narrow-to-subtree)
         (goto-char epigeal-pt)
         (olivetti-mode))
       clone-of-file-buffer)))

(org-link-set-parameters
 "epigeal"
 :follow (lambda (path)
           (-let* (((org-id pt) (split-string  path "::")))
             (id->cloned-narrow-subtree-occur org-id query))))

(org-link-set-parameters
 "subtree-occur"
 :follow (lambda (path)
           (-let* (((org-id query) (split-string  path "/")))
             (id->cloned-narrow-subtree-occur org-id query))))



(defface text-clone-overlay-face '((t :background "yellow"))
  "Face for marking regions to be cloned.")

(defvar-local text-clone-overlay nil
  "Store for the region to be cloned.")

(defun text-clone-mark-region (b e)
  "Mark region from B to E for cloning."
  (interactive "r")
  (if text-clone-overlay
      (move-overlay text-clone-overlay b e)
    (setq text-clone-overlay (make-overlay b e))
    (overlay-put text-clone-overlay 'face 'text-clone-overlay-face)))

(defun text-clone-copy (point)
  "Copy the clone overlay region and create text-clone at POINT."
  (interactive "d")
  (let ((b (overlay-start text-clone-overlay))
    (e (overlay-end text-clone-overlay)))
    (when (and (>= point b)
           (< point e))
      (user-error "Point within cloned region"))
    (let ((str (buffer-substring b e)))
      (insert str)
      (save-excursion
    (goto-char point)
    (text-clone-create b e)))))

(defvar-local text-clone-list nil
  "List of text clones in current buffer.")

(defun text-clone-list (&optional begin end)
  "Get clones in region from begin to end."
  (let* ((cnt -1)
     (ols (cl-loop for ol being the overlays
              if (overlay-get ol 'text-clones)
              do (overlay-put ol 'text-clone-index (cl-incf cnt))
              and collect ol))
     ret)
    (dolist (ol ols)
      (setq ret (cons
         (append
          (list
           (overlay-start ol)
           (overlay-end ol))
          (mapcar
           (lambda (clone)
             (overlay-get clone 'text-clone-index))
          (overlay-get ol 'text-clones)))
         ret)))
    (nreverse ret)))

(defun text-clone-save ()
  "Add `text-clone-list' as local variable."
  (save-excursion
    (add-file-local-variable 'text-clone-list (text-clone-list))))

(defun text-clone-read ()
  "Create text clones according to `text-clone-list'."
  (let (clones)
    (dolist (clone text-clone-list)
      (let ((ol (make-overlay (car clone) (cadr clone))))
    (overlay-put ol 'text-clones (nthcdr 2 clone))
    (setq clones (cons ol clones))))
    (setq clones (nreverse clones))
    (dolist (clone clones)
      (overlay-put clone
       'text-clones
       (mapcar (lambda (idx)
         (nth idx clones))
           (overlay-get clone 'text-clones)))
      (overlay-put clone 'modification-hooks '(text-clone--maintain))
      (overlay-put clone 'evaporate t))))

(define-minor-mode text-clone-mode
  "Make text clones permanent in their file."
  nil
  nil
  nil
  (if text-clone-mode
      (progn
    (add-hook 'after-change-major-mode-hook #'text-clone-read t t)
    (add-hook 'before-save-hook #'text-clone-save t t))
    (save-excursion (add-file-local-variable 'text-clone-list nil))
    (remove-hook 'before-save-hook #'text-clone-save t)
    (remove-hook 'after-change-major-mode-hook #'text-clone-read t)))

;; (add-hook 'org-mode-hook #'text-clone-mode)

(defconst org+-counselrg-link-type "counselrg"
  "String for identifying counsel-rg links.")

(defun org+-buffer-base-name (buffer-name)
  "Remove trailing <.*> in BUFFER-NAME."
  (save-match-data
    (when (string-match "<[^<>]+>\\'" buffer-name)
      (setq buffer-name (substring buffer-name nil (match-beginning 0)))))
  buffer-name)

(defun org+-counselrg-store ()
  "Store links of type counselrg:LINK-PATH."
  (when (derived-mode-p 'ivy-occur-grep-mode)
    (org-store-link-props :type org+-counselrg-link-type
              :link (format "%s:%S" org+-counselrg-link-type (cons default-directory (org+-buffer-base-name (buffer-name))))
              :description (format "%s in %s" (buffer-name) default-directory))
    t))

(defun org+-counselrg-follow (link-path)
  "Follow org-links of type counselrg:LINK-PATH."
  (let* ((caller-window (get-buffer-window))
     (dir-buf (read link-path))
     (dir-name (car dir-buf))
     (buf-name (cdr dir-buf))
     (buf
      ;; First try to re-use already existing buffer.
      (cl-loop for buf in (buffer-list)
           if (with-current-buffer buf
            (and
             (derived-mode-p 'ivy-occur-grep-mode)
             (file-equal-p default-directory dir-name)
             (string-equal
              (org+-buffer-base-name (buffer-name))
              buf-name
              )))
           do (with-current-buffer buf (ivy-occur-revert-buffer))
           and return buf
           finally
           ;; if there is no buffer for re-use:
           return
           (with-current-buffer (generate-new-buffer buf-name)
             (setq default-directory dir-name)
             (ivy-occur-grep-mode)
             (let ((inhibit-read-only t)
               (counsel-ag-base-command counsel-rg-base-command))
               (setq-local ivy-occur-last
                   (make-ivy-state
                    :directory default-directory
                    :caller 'counsel-ag
                    :window caller-window
                    :buffer (current-buffer)
                    ))
               (counsel-ag-occur))
             (current-buffer))
           )))
    (switch-to-buffer buf)))


(org-link-set-parameters org+-counselrg-link-type
             :follow #'org+-counselrg-follow
             :store #'org+-counselrg-store)

(use-package org-sidebar
  :quelpa (org-sidebar :fetcher github :repo "alphapapa/org-sidebar"))

(defun bmkp-store-org-link-2 ()
  "Store a link to a bookmark for insertion in an Org-mode buffer.
See command `bmkp-store-org-link'."
  (interactive)
    (require 'org)
    (let* ((other-win  (and current-prefix-arg  (not (consp current-prefix-arg))))
           (bmk        (bmkp-completing-read-lax
                        (format "Store %sOrg link for bookmark" (if other-win "other-window " ""))))
           (link       (format "bookmark%s:%s" (if other-win "-other-win" "") bmk))
           (bmk-desc   (format "Bookmark: %s" bmk)))
      ;; (org-store-link-props :type "bookmark" :link link :description bmk-desc)
      (push (list link bmk-desc) org-stored-links)
      t))

(defun my/org-journal-prompt ()
  "Show my Org Today Sidebar."
  (interactive)
  (org-sidebar-ql (org-agenda-files)
  '(tags "journal_prompt")
  ;; :action element-with-markers
  )
  (org-ql-view )
  
  )

;; random freewrite

(defun random-choice (items)
  (let* ((size (length items))
         (index (random size)))
    (nth index items)))

(defun indirect-goto (headline)
    (interactive)
    (let ((marker (get-text-property 0 'marker headline)))
      (when (markerp marker)
        (with-current-buffer
            (with-current-buffer (marker-buffer marker)
              (clone-indirect-buffer nil t))
          (goto-char marker)
          (org-show-context)
          (org-narrow-to-element)
          (org-show-entry)
          (olivetti-mode)))))

(defun jhnn/random-freewrite ()
  (interactive)
  (->>  (org-ql-select "~/orgs/structure/journal/2020/freewrites.org"
          '(or (heading "350") (heading "340"))
          :action (lambda ()
                    (propertize (org-get-heading t)
                                'marker (copy-marker (point)))))
        random-choice
        indirect-goto))


;; (push (cons "Overview: journal prompts"
;;             (list :buffers-files #'org-agenda-files
;;                   :query '(tags "journal_prompt")
;;                   :sort '(date priority)
;;                   :super-groups 'org-super-agenda-groups
;;                   :title "journal prompts"))
;; )

;; (setq
;; jhnnprompts 
;; (ivy-completing-read "Choose prompt, bruh"
;;                      (org-ql (org-agenda-files)
;;                        (tags "journal_prompt")
;;                        :action (lambda ()
;;                                  (propertize (org-get-heading t)
;;                                              'marker (copy-marker (point))))

;;                        )))



;; '(and (not (done))
;;                            (or (habit)
;;                                (deadline auto)
;;                                (scheduled :to today)
;;                                (ts-active :on today)))

