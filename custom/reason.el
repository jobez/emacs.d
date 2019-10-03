(load "~/exps/langs/reasonml/dev/reason-mode/reason-indent.el")
(load "~/exps/langs/reasonml/dev/reason-mode/refmt.el")
(load "~/exps/langs/reasonml/dev/reason-mode/reason-interaction.el")
(load "~/exps/langs/reasonml/dev/reason-mode/reason-mode.el")

(defun chomp-end (str)
  "Chomp tailing whitespace from STR."
  (replace-regexp-in-string (rx (* (any " \t\n")) eos)
                            ""
                            str))

(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
   an error"
  (let ((stdoutput (chomp-end
                    (with-output-to-string
                      (with-current-buffer
                          standard-output
                        (process-file shell-file-name nil
                                      '(t nil)  nil
                                      shell-command-switch cmd))))))
    (when (not (= (length stdoutput) 0))
      stdoutput)))

(let* ((refmt-bin (shell-cmd "refmt ----where"))
       (merlin-bin "ocamlmerlin")
       (merlin-base-dir (when merlin-bin (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
  ;; Add npm merlin.el to the emacs load path and tell emacs where to find ocamlmerlin
  (when merlin-bin
    (add-to-list 'load-path (concat merlin-base-dir "share/emacs/site-lisp/"))
    (setq merlin-command merlin-bin))

  (when refmt-bin
    (setq refmt-command refmt-bin)))


(add-to-list 'load-path "/nix/store/0b0rjss6gr2nf4piyn01zc4fqkmx1lmp-merlin-2.5.4/share/emacs/site-lisp")
(require 'reason-mode)
(require 'merlin)
(add-hook 'reason-mode-hook (lambda ()
                              (add-hook 'before-save-hook 'refmt-before-save)
                              (merlin-mode)))

(setq merlin-ac-setup t)


(require 'utop)
(setq utop-command "opam config exec -- rtop -emacs")
(add-hook 'reason-mode-hook #'utop-minor-mode) ;; can be included in the hook above as well
