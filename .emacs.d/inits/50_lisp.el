;; clisp
;(add-to-list 'load-path "~/.emacs.d/site-lisp/slime-2.0")
;(setq inferior-lisp-program "clisp")
;(require 'slime)
;(add-hook 'lisp-mode-hook (lambda ()
;                            (slime-mode t)
;                            (show-paren-mode)))
;(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;(slime-setup)


;; gauche
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))
(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme" t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process" t)
