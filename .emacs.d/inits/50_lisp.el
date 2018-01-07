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
;(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme" t)
;(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process" t)

(require 'gauche-mode)
(setq auto-mode-alist
     (cons '("\.\(scm\)$" . gauche-mode) auto-mode-alist))
(autoload 'gauche-mode "gauche-mode" "Major mode for Scheme." t)
(autoload 'run-scheme "gauche-mode" "Run an inferior Scheme process." t)
;(setq initial-major-mode 'gauche-mode)


(defvar anything-c-source-info-gauche-refj
   ;; '((info-index . "~/../gauche/share/info/gauche-refj.info")))
  '((info-index . "gauche-refj.info")))
(defun anything-info-ja-at-point ()
  "Preconfigured `anything' for searching info at point."
  (interactive)
  (anything '(anything-c-source-info-gauche-refj)
            (thing-at-point 'symbol) nil nil nil "*anything info*"))
(define-key global-map (kbd "C-M-;") 'anything-info-ja-at-point)

(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme" t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process" t)


;; Clojure
(add-hook 'clojure-mode-hook 'cider-mode)

;; mini bufferに関数の引数を表示させる
;; (add-hook 'cider-mode-hook 'turn-on-eldoc-mode)

;; 'C-x b' した時に *nrepl-connection* と *nrepl-server* のbufferを一覧に表示しない
;(setq nrepl-hide-special-buffers t)

;; REPLのbuffer名を 'project名:nREPLのport番号' と表示する
;; project名は project.clj で defproject した名前
(setq nrepl-buffer-name-show-port t)

;;     ac-cider
(autoload 'ac-cider "ac-cider" nil t)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

;(defun set-auto-complete-as-completion-at-point-function ()
;  (setq completion-at-point-functions '(auto-complete)))
;(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
;
;(add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
;(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)


;;     kibit
;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
         '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))


;; clj-refactor
(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               (cljr-add-keybindings-with-prefix "C-c C-c")
                               (lambda () (yas/minor-mode 1))))

;; clojure-mode
(require 'clojure-mode)
(define-clojure-indent
  (defroutes 'defun)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 2))

;; for cider-connect
(setq nrepl-use-ssh-fallback-for-remote-hosts t)

;; paredit
; (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
; (add-hook 'lisp-interacton-mode-hook 'enable-paredit-mode)
; (add-hook 'clojure-mode-hook 'enable-paredit-mode)


;; parinfer
(use-package parinfer
  :ensure t
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
