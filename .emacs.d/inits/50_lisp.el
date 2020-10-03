;;; eldoc
(setq eldoc-echo-area-use-multiline-p t)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)


;;; Clojure
(use-package clojure-mode
  :after (cider clj-refactor flycheck-clj-kondo cljstyle-mode)
  :mode ("\\.clj\\'" . clojure-mode)
  :hook ((clojure-mode . cider-mode)
         (clojure-mode . company-mode)
         (clojure-mode . clj-refactor-mode)
         (clojure-mode . flycheck-mode)
         (clojure-mode . cljstyle-mode))
  :config
  (define-key clojure-mode-map (kbd "C-c SPC") 'win-toggle-window)
  (define-clojure-indent
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (context 2)))

(use-package cljstyle-mode
  :load-path "~/.emacs.d/site-lisp")

(use-package cider
  :config
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (setq nrepl-buffer-name-show-port t ;; TODO: obsolete? cider-session-name-template
        nrepl-use-ssh-fallback-for-remote-hosts t ;; cider-connect
        ;;nrepl-log-messages t
        ;;cider-repl-display-in-current-window t
        ;;cider-repl-use-clojure-font-lock t
        ;;cider-save-file-on-load 'always-save
        ;;cider-font-lock-dynamically '(macro core function var)
        ;;cider-overlays-use-font-lock t
        )
  (emidje-setup))
;;(cider-repl-toggle-pretty-printing)

(use-package clj-refactor
  :config (cljr-add-keybindings-with-prefix "C-c j"))

(use-package flycheck-clj-kondo
  :ensure t)

;; For repl
;; (setq *print-length* 10)
;; (setq *print-level* 10)

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interacton-mode-hook 'enable-paredit-mode)
  (add-hook 'clojure-mode-hook 'enable-paredit-mode))

;; parinfer
(use-package parinfer
  :disabled
;;  :bind (("C-," . parinfer-toggle-mode))
  :init (progn
          (setq parinfer-extensions
                '(defaults       ; should be included.
                   pretty-parens  ; different paren styles for different modes.
;;                   evil           ; If you use Evil.
;;                   lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
                   paredit        ; Introduce some paredit commands.
                   smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
                   smart-yank))   ; Yank behavior depend on mode.
          (add-hook 'clojure-mode-hook #'parinfer-mode)
          (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
          (add-hook 'common-lisp-mode-hook #'parinfer-mode)
          (add-hook 'scheme-mode-hook #'parinfer-mode)
          (add-hook 'lisp-mode-hook #'parinfer-mode)))
