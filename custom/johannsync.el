(require 'manage-minor-mode)

(defun get-buffers-with-minor-mode (minor-mode)
  "Get a list of buffers in which minor-mode is active"
  (interactive)
  (let ((minor-mode-buffers))
    (dolist (buf (buffer-list) minor-mode-buffers)
      (with-current-buffer buf
        (when (memq minor-mode (manage-minor-mode--active-list))
          (push buf minor-mode-buffers))))))


(defun johannsave (path)
  (dolist (buffer (get-buffers-with-minor-mode 'johannsync))
    (with-current-buffer (find-file-noselect (concat path
                                                     (buffer-name buffer)
                                                     ".org"))
      (when (not (string= (md5 buffer)
                          (save-excursion
                            (progn (end-of-buffer)
                                   (forward-line -1))
                            (buffer-substring-no-properties (point)
                                                            (line-end-position)))))
        (save-excursion
          (end-of-buffer)
          (insert (concat "* " (current-time-string)))
          (newline)
          (insert-buffer buffer))
        (end-of-buffer)
        (newline 2)
        (insert (md5 buffer))
        (save-buffer)
        (message "great thoughts preserved")))))

(defun killtimer ()
  (cancel-function-timers 'johannsave))
