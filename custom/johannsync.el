(require 'manage-minor-mode)

(defun get-buffers-with-minor-mode (minor-mode)
  "Get a list of buffers in which minor-mode is active"
  (interactive)
  (let ((minor-mode-buffers))
    (dolist (buf (buffer-list) minor-mode-buffers)
      (with-current-buffer buf
        (when (memq minor-mode (manage-minor-mode--active-list))
          (push buf minor-mode-buffers))))))


(defun johannsave ()
  (dolist (buffer (get-buffers-with-minor-mode 'johannsync))
    (with-current-buffer (find-file-noselect (concat "~/.brilliant-buffers/"
                                                     (buffer-name buffer)
                                                     ".org"))
      (when (not (= (md5 buffer)
                    (save-excursion
                      (forward-line -1)
                      (buffer-substring-no-properties (point)
                                                      (line-end-position)))))
        (message "buffer modified i guess")
        (goto-char (point-max))
        (insert (concat "* " (current-time-string)))
        (newline)
        (insert (md5 buffer))
        (save-excursion
          (insert-buffer buffer))
        (save-buffer)
        (message "great thoughts preserved")))))



(define-minor-mode johannsync
  "when i have hotflashes of brilliance in a buffer and i want to sync it for safe keeping"
  :lighter "syncy syncy"
  :syn
  :keymap (let ((kmap (make-sparse-keymap)))
            (define-key kmap (kbd "C-c j r")
              #'remove-from-sync-registry)
            kmap)
  (run-with-idle-timer 30 t #'johannsave))
