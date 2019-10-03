(defun expand-directory-name (dir &optional parent-dir)
  (file-name-as-directory (expand-file-name dir parent-dir)))
(defun in-nix-shell-p ()
  (string-equal (getenv "IN_NIX_SHELL") "1"))


(use-package tuareg
  :ensure t
  :mode (("\\.ml[ilpy]?\\'" . tuareg-mode)
         ("\\.eliomi?\\'"   . tuareg-mode))
  :init
  (defun ht-setup-tuareg ()
    (when (executable-find "opam")
      (dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
        (setenv (car var) (cadr var))))
    (let ((ocaml-toplevel-path (getenv "OCAML_TOPLEVEL_PATH")))
      (when ocaml-toplevel-path
        (add-to-list 'load-path (expand-directory-name "../../share/emacs/site-lisp" ocaml-toplevel-path))))
    (when (in-nix-shell-p)
      (let ((merlin-site-lisp (getenv "MERLIN_SITE_LISP"))
            (utop-site-lisp   (getenv "UTOP_SITE_LISP"))
            (ocamlinit        (getenv "OCAMLINIT")))
        (when merlin-site-lisp
          (add-to-list 'load-path merlin-site-lisp))
        (when utop-site-lisp
          (add-to-list 'load-path utop-site-lisp))
        (when ocamlinit
          (setq tuareg-opam                nil
                org-babel-ocaml-command    (format "ocaml -init %s"       ocamlinit)
                tuareg-interactive-program (format "ocaml -init %s"       ocamlinit)
                utop-command               (format "utop -emacs -init %s" ocamlinit)))))
    )
  (ht-setup-tuareg)
  ;; (require 'tuareg)
  (require 'ocp-indent)
  (use-package merlin
    :if (executable-find "ocamlmerlin")
    :commands merlin-mode
    :defines merlin-command
    :init
    (add-hook 'merlin-mode-hook 'company-mode)
    (add-hook 'tuareg-mode-hook 'merlin-mode)
    :config
    (when (and (executable-find "opam")
               (not (in-nix-shell-p)))
      (setq merlin-command 'opam))
    (add-to-list 'company-backends 'merlin-company-backend))
  (use-package utop
    :if (executable-find "utop"))
  (use-package utop-minor-mode
    :if (executable-find "utop")
    :init
    (when (fboundp 'utop-minor-mode)
      (add-hook 'tuareg-mode-hook 'utop-minor-mode)))
  :config
  (setq tuareg-indent-align-with-first-arg nil))
