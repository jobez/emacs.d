;; Package-Requires: ((dash "2.6.0") (dash-functional "1.0.0") (emacs "24"))

(require 'rvm)
(require 'dash)
(require 'prodigy)

(prodigy-define-tag
  :name 'puma
  :ready-message "Use Ctrl-C to stop")

(prodigy-define-tag
  :name 'correlate-clj
  :ready-message "Correlate clj rest server enabled on port")

(prodigy-define-tag
  :name 'ccs3
  :ready-message "http server listening on port")


(prodigy-define-service
  :name "Correlate Puma"
  :command "bundle"
  :cwd "/Users/HereNow/code/ib5k/correlate/aware_accounts/correlate/"
  :path '("/Users/HereNow/code/ib5k/correlate/aware_accounts/correlate/")
  :port 3000
  :args '("exec" "puma" "-p" "3000")
  :tags '(correlate ruby puma)
  :kill-signal 'kill
  :kill-process-buffer-on-stop t
  :truncate-output 1000
  :on-output (lambda (service output)
               (when (s-matches? "Use Ctrl-C to stop" output)
                 (prodigy-set-status service 'ready)))
  :init-async (lambda (done)
                (rvm-activate-ruby-for "/Users/HereNow/code/ib5k/correlate/aware_accounts/correlate/" done)))

(prodigy-define-service
  :name "Correlate clj (dev/qa)"
  :command "lein"
  :cwd "/Users/HereNow/code/ib5k/correlate/aware_accounts/clj/"
  :args '("run" "-m" "correlate.core/-run-dev-mode")
  :tags '(correlate clojure correlate-clj)
  :kill-signal 'kill
  :kill-process-buffer-on-stop t
  :truncate-output 1000)

(prodigy-define-service
  :name "CCS3 (dev/qa)"
  :command "lein"
  :cwd "/Users/galin/Work/platformis/git/ccs3"
  :args '("pdo" "cljsbuild" "auto," "run")
  :tags '(clojure ccs3)
  :kill-signal 'kill
  :kill-process-buffer-on-stop t
  :truncate-output 1000)

(provide 'db-prodigy)
