(or (getenv "OZHOME")
    (setenv "OZHOME"
            ""))   ; or wherever Mozart is installed
(setenv "PATH" (concat (getenv "OZHOME") "/bin:" (getenv "PATH")))

(setq load-path (cons "/nix/store/1xvqagd49150ldhsz0269q5d0x8x4x76-mozart-binary-2.0.0/share/mozart/elisp"
                      load-path))
(setq auto-mode-alist
      (append '(("\\.oz\\'" . oz-mode)
                ("\\.ozg\\'" . oz-gump-mode))
              auto-mode-alist))

(require 'mozart)
(require 'oz)
(require 'oz-extra)
(require 'oz-server)

(autoload 'run-oz "oz" "" t)
(autoload 'oz-mode "oz" "" t)
(autoload 'oz-gump-mode "oz" "" t)
(autoload 'oz-new-buffer "oz" "" t)

(setq *oz-engine-program* "ozengine")

(setq *OZHOME* "")
