;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RFZ Search

(defun rs (x)
  (interactive "srfz-search: ")
  (grep (format "%s %s" "~/bin/rfzsearch" x)))


(defun rfzsearch-with-symbol-at-point ()
  (interactive)
  (grep (format "%s %s" "~/bin/rfzsearch" (symbol-at-point))))

(global-set-key (kbd "C-7") 'rfzsearch-with-symbol-at-point)
