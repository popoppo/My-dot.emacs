;; Earlang
(setq erlang-root-dir "/home/takahashi/lib/erlang")
(setq load-path (cons "/home/takahashi/lib/erlang/lib/tools-2.6.5.1/emacs" load-path))
(setq exec-path (cons "/home/takahashi/lib/erlang/bin" exec-path))
(add-to-list 'load-path 
             (expand-file-name "~/.emacs.d/site-lisp/erlang"))
(require 'erlang-start)
(add-hook 'erlang-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; distel(erlang)
(let ((distel-dir "/usr/local/share/distel/elisp"))
  (unless (member distel-dir load-path)
    ;; Add distel-dir to the end of load-path
    (setq load-path (append load-path (list distel-dir)))))
(require 'distel)
(distel-setup)

;; Some Erlang customizations
(add-hook 'erlang-mode-hook
	  (lambda ()
	    ;; when starting an Erlang shell in Emacs, default in the node name
	    (setq inferior-erlang-machine-options '("-sname" "emacs"))
	    ;; add Erlang functions to an imenu menu
	    (imenu-add-to-menubar "imenu")))

;; A number of the erlang-extended-mode key bindings are useful in the shell too
(defconst distel-shell-keys
  '(;("\C-\M-i"   erl-complete)
    ("\C-t?"      erl-complete)	
    ;("\M-."      erl-find-source-under-point)
    ("\C-tt"      erl-find-source-under-point)
    ;("\M-,"      erl-find-source-unwind) 
    ;("\M-*"      erl-find-source-unwind) 
    ("\C-tb"      erl-find-source-unwind) 
    )
  "Additional keys to bind when in Erlang shell.")

(add-hook 'erlang-shell-mode-hook
	  (lambda ()
	    ;; add some Distel bindings to the Erlang shell
	    (dolist (spec distel-shell-keys)
	      (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

(setq erl-nodename-cache
      (make-symbol
       (concat
        "emacs@"
        ;; Mac OS X uses "name.local" instead of "name", this should work
        ;; pretty much anywhere without having to muck with NetInfo
        ;; ... but I only tested it on Mac OS X.
        (car (split-string (shell-command-to-string "hostname"))))))
