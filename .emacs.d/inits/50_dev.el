;; gtags
(autoload 'gtags-mode "gtags" "" t)

(global-set-key "\C-cg" 'gtags-mode)

(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\C-tt" 'gtags-find-tag)
         (local-set-key "\C-tr" 'gtags-find-rtag)
         (local-set-key "\C-ts" 'gtags-find-symbol)
         (local-set-key "\C-tp" 'gtags-find-pattern)
         (local-set-key "\C-tb" 'gtags-pop-stack)))
;      (local-set-key "\M-t" 'gtags-find-tag)
;      (local-set-key "\M-r" 'gtags-find-rtag)
;      (local-set-key "\M-s" 'gtags-find-symbol)
;      (local-set-key "\M-p" 'gtags-find-pattern)
;      (local-set-key "\C-t" 'gtags-pop-stack)))

(defun gtags-show-buffer-stack ()
  (interactive)
  (print *gtags-buffer-stack-alist*))

(defun gtags-show-buffer-list ()
  (interactive)
  (print *gtags-current-buffer-alist*))

(require 'eldoc)
(require 'eldoc-extension)
;(setq eldoc-idle-delay 0.20)
(setq eldoc-echo-area-use-multiline-p t)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)


;; C/C++
(add-hook 'c-mode-hook
    '(lambda ()
       (c-turn-on-eldoc-mode)
       (make-variable-buffer-local 'skeleton-pair)
       (make-variable-buffer-local 'skeleton-pair-on-word)
       (make-variable-buffer-local 'skeleton-pair-alist)
       (setq skeleton-pair-on-word t)
       (setq skeleton-pair t)
       (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
       (gtags-mode 1)))
       ;(gtags-make-complete-list)))

(add-hook 'c++-mode-hook
    '(lambda ()
       (make-variable-buffer-local 'skeleton-pair)
       (make-variable-buffer-local 'skeleton-pair-on-word)
       (make-variable-buffer-local 'skeleton-pair-alist)
       (setq skeleton-pair-on-word t)
       (setq skeleton-pair t)
       (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
       (local-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
       (gtags-mode 1)))

;; PHP
(load-library "php-mode")
(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.module$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.install$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.engine$" . php-mode))

(add-hook 'php-mode-hook
    '(lambda ()
       (local-unset-key (kbd "C-."))))


;; Python
(require 'python)
(setq
  python-shell-interpreter "ipython"
  python-shell-interpreter-args "--pylab"
  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
  python-shell-completion-setup-code
    "from IPython.core.completerlib import module_completion"
  python-shell-completion-module-string-code
    "';'.join(module_completion('''%s'''))\n"
  python-shell-completion-string-code
    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; For flymake
(when (load "flymake" t)
  (defun flymake-python-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pychecker.sh" (list local-file)))) ; substitute epylint for this
  (push '(".+\\.py$" flymake-python-init) flymake-allowed-file-name-masks))

;; Hooks
(add-hook 'python-mode-hook
           '(lambda ()
              (jedi:setup)
              (jedi:ac-setup)
              (define-key python-mode-map (kbd "<C-return>") 'jedi:complete)
              (unless (eq buffer-file-name nil) (flymake-mode t))))


;; Java
(add-hook 'java-mode-hook
    '(lambda ()
       (gtags-mode 1)))

;; jdee
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic/bovine"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/common"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/eieio"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/speedbar"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/jde/lisp"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/elib"))

; cedet
(load "cedet")

(autoload 'jde-mode "jde" "Java Development Environment for Emacs." t)
(setq auto-mode-alist (cons '("\.java$" . my-jde-mode) auto-mode-alist))
(defun my-jde-mode ()
  (jde-mode)
  (jde-jdb-minor-mode -1))

(setq jde-ant-enable-fine t)
(setq jde-ant-program "/usr/bin/ant")
(setq jde-ant-read-target t)
(setq jde-build-function (quote (jde-ant-build)))
(setq jde-enable-abbrev-mode t)
(setq jde-gen-cflow-enable t)
(setq tempo-interactive t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(jde-ant-enable-find t)
 '(jde-ant-home "/usr/local/dev/ant")
 '(jde-ant-program "/usr/local/dev/ant/bin/ant" t)
 '(jde-ant-working-directory "")
 '(jde-compile-option-classpath nil)
 '(jde-gen-final-arguments nil)
 '(jde-gen-final-methods nil)
 '(jde-jdk-registry (quote (("1.5" . "/usr/local/java/jdk-1.5")))))
; '(jde-jdk "1.5")

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;; mcomplete
;;;(require 'mcomplete)
;;;(turn-on-mcomplete-mode)


;; rst-mode
(autoload 'rst-mode "rst-mode" "mode for editing reStructuredText documents" t)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))


;;; Autoloads for magit
(require 'magit)


;; Complete parentheses
(setq skeleton-pair t)
(defvar skeletons-alist
  '((?\( . ?\))
    (?\" . ?\")
    (?[  . ?])
    (?{  . ?})
    (?$  . ?$)))

(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)


;; imenu
(setq imenu-auto-rescan t)
(setq imenu-after-jump-hook (lambda () (recenter 10)))

;; git-gutter
(load "git-gutter")
(global-git-gutter-mode t)
