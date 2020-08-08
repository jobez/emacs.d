;; exwm stuff
(when (fboundp 'fringe-mode)
    (fringe-mode 0))

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))


(setq display-time-default-load-average nil)
(display-time-mode t)

 (display-battery-mode t)


(require 'exwm)
(require 'counsel)
;; Set the initial number of workspaces.
(setq exwm-workspace-number 10)

;; All buffers created in EXWM mode are named "*EXWM*". You may want to change
;; it in `exwm-update-class-hook' and `exwm-update-title-hook', which are run
;; when a new window class name or title is available. Here's some advice on
;; this subject:
;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;; + Only renaming buffer in one hook and avoid it in the other. There's no
;;   guarantee on the order in which they are run.
;; + For applications with multiple windows (e.g. GIMP), the class names of all
;;   windows are probably the same. Using window titles for them makes more
;;   sense.
;; + Some application change its title frequently (e.g. browser, terminal).
;;   Its class name may be more suitable for such case.
;; In the following example, we use class names for all windows expect for
;; Java applications and GIMP.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))

(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

;; The following example demonstrates how to set a key binding only available
;; in line mode. It's simply done by first push the prefix key to
;; `exwm-input-prefix-keys' and then afdd the key sequence to `exwm-mode-map'.
;; The example shorten 'C-c q' to 'C-q'.
(push ?\C-q exwm-input-prefix-keys)
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when (and exwm-class-name
                       (string= exwm-class-name "XTerm"))
              (exwm-input-set-local-simulation-keys  '(([?\C-c ?\C-c] . ?\C-c))))))

;; The following example demonstrates how to use simulation keys to mimic the
;; behavior of Emacs. The argument to `exwm-input-set-simulation-keys' is a
;; list of cons cells (SRC . DEST), where SRC is the key sequence you press and
;; DEST is what EXWM actually sends to application. Note that SRC must be a key
;; sequence (of type vector or string), while DEST can also be a single key.
(exwm-input-set-simulation-keys
 '(([?\C-b] . left)
   ([?\C-f] . right)
   ([?\C-p] . up)
   ([?\C-n] . down)
   ([?\C-a] . home)
   ([?\C-e] . end)
   ([?\M-v] . prior)
   ([?\C-v] . next)
   ([?\C-d] . delete)
   ([?\C-k] . (S-end delete))))

(defun exwm-config-example ()
  "Default configuration of EXWM."
  ;; Set the initial workspace number.
  (unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 4))
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            ([?\s-r] . exwm-reset)
            ;; 's-w': Switch workspace.
            ([?\s-w] . exwm-workspace-switch)
            ;; 's-&': Launch application.
            ([?\s-&] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))
            ;; 's-N': Switch to certain workspace.
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9)))))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    )
  ;; Enable EXWM
  (exwm-enable)
  ;; Configure Ido
  (exwm-config-ido)
  ;; Other configurations
  (exwm-config-misc))

(setq exwm-input-simulation-keys
          '(([?\C-b] . [left])
            ([?\C-f] . [right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete])))
;; You can hide the mode-line of floating X windows by uncommenting the
;; following lines
(add-hook 'exwm-floating-setup-hook #'exwm-layout-hide-mode-line)
(add-hook 'exwm-floating-exit-hook #'exwm-layout-show-mode-line)

;; You can hide the minibuffer and echo area when they're not used, by
;; uncommenting the following line
;; (setq exwm-workspace-minibuffer-position 'top)

;; Do not forget to enable EXWM. It will start by itself when things are ready.
(require 'exwm-systemtray)
(exwm-systemtray-enable)

;; `exwm-input-set-key' allows you to set a global key binding (available in
;; any case). Following are a few examples.
;; + We always need a way to go back to line-mode from char-mode
(exwm-input-set-key (kbd "s-r") #'exwm-reset)
;; + Bind a key to switch workspace interactively
(exwm-input-set-key (kbd "s-w") #'exwm-workspace-switch)
;; + Bind "s-0" to "s-9" to switch to the corresponding workspace.
(dotimes (i 10)
  (exwm-input-set-key (kbd (format "s-%d" i))
                      `(lambda ()
                         (interactive)
                         (exwm-workspace-switch-create ,i))))
;; + Application launcher ('M-&' also works if the output buffer does not
;;   bother you). Note that there is no need for processes to be created by
;;   Emacs.
(exwm-input-set-key (kbd "s-&")
                    (lambda (command)
                      (interactive (list (read-shell-command "$ ")))
                      (start-process-shell-command command nil command)))

;; + 'slock' is a simple X display locker provided by suckless tools.
(exwm-input-set-key (kbd "s-<f2>")
                    (lambda () (interactive) (start-process "" nil "slock")))

(exwm-input-set-key (kbd "C-s-x")
                    #'counsel-linux-app)

(defun full-screenshot ()
  (interactive)
  (shell-command "imgur-screenshot&"))

;; (defun emacs-everywhere ()
;;   (interactive)
;;   (shell-command "~/.emacs_anywhere/bin/run"))

(defun launch-xterm ()
  (interactive)
  (shell-command "xterm&"))

(defun gifgrab ()
  (interactive)
  (shell-command "gifgrab&"))

(defun select-screenshot ()
  (interactive)
  (shell-command "imgur-screenshot&"))

(defun systemctl-suspend ()
  (interactive)
  (shell-command "systemctl suspend"))

(exwm-input-set-key (kbd "s-<print>") 'full-screenshot)

(exwm-input-set-key (kbd "s-t") 'eshell)

(exwm-input-set-key (kbd "C-s-t") 'launch-xterm)

(exwm-input-set-key (kbd "C-s-s") 'systemctl-suspend)

;; (exwm-input-set-key (kbd "C-s-c") 'emacs-everywhere)

(use-package exwm-edit)

(exwm-input-set-key (kbd "C-s-<print>") 'select-screenshot)

(exwm-input-set-key (kbd "C-s-<insert>") 'gifgrab)

(add-to-list 'display-buffer-alist '("^*Async Shell Command*" . (display-buffer-no-window)))

(exwm-input-set-key (kbd "M-y") #'jhnn/exwm-counsel-yank-pop)

(defun jhnn/exwm-counsel-yank-pop ()
  "Same as `counsel-yank-pop' and paste into exwm buffer."
  (interactive)
  (let ((inhibit-read-only t)
        ;; Make sure we send selected yank-pop candidate to
        ;; clipboard:
        (yank-pop-change-selection t))
    (call-interactively #'counsel-yank-pop))
  (message "jhnn")
  (when (derived-mode-p 'exwm-mode)
    ;; https://github.com/ch11ng/exwm/issues/413#issuecomment-386858496
    (message "jhnn")
    (exwm-input--set-focus (exwm--buffer->id (window-buffer (selected-window))))
    (exwm-input--fake-key ?\C-v)))



(progn
 (add-to-list 'load-path "~/exps/emacs/gpastel")
 (add-hook 'exwm-init-hook #'gpastel-mode))

(exwm-enable)


(server-start)
