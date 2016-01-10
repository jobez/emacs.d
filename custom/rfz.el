;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RFZ Search

(defun rs (x)
  (interactive "srfz-search: ")
  (grep (format "%s %s" "~/bin/rfzsearch" x)))

(defun rfzsearch-with-symbol-at-point ()
  (interactive)
  (grep (format "%s %s" "~/bin/rfzsearch" (symbol-at-point))))

;;;;;;;;;;;;;;;;;;;;;;;;;
;; RFZ cljs

(defun rfz-cljs (build-name)
  (interactive "srfz build?: ")
  (with-current-buffer (format "*cljsbuild* %s" build-name)
    (kill-buffer))
  (save-window-excursion
    (let ((default-directory "~/rfz/debtapp/app/"))
      (async-shell-command (format  "lein rfz cljs %s auto" build-name))))
  (with-current-buffer "*Async Shell Command*"
    (rename-buffer (format "*cljsbuild* %s" build-name))))


(define-minor-mode rfz-mode
  "RFZ stuff"
  :keymap (let ((kmap (make-sparse-keymap)))
            (define-key kmap (kbd "H-1") #'rfzsearch-with-symbol-at-point)
            (define-key kmap (kbd "H-2") #'rfz-cljs)
            kmap))

(dir-locals-set-class-variables 'rfz
                                '((nil . ((eval . (rfz-mode))))))

(dir-locals-set-directory-class
 "~/rfz/"  'rfz)

(provide 'rfz-mode)
