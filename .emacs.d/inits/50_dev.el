;; gtags
(autoload 'gtags-mode "gtags" "" t)

;;(global-set-key "\C-cg" 'gtags-mode)

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
;(require 'eldoc-extension)
;(setq eldoc-idle-delay 0.20)
(setq eldoc-echo-area-use-multiline-p t)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)

;; C/C++
(add-hook 'c-mode-hook
    '(lambda ()
       ;(gtags-make-complete-list)))
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
       (gtags-mode 1)
       (gtags-make-complete-list)))

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
(use-package php-mode
  :mode
  (("\\.module$"  . php-mode)
   ("\\.inc$"     . php-mode)
   ("\\.install$" . php-mode)
   ("\\.engine$"  . php-mode))
  :init
  (add-hook 'php-mode-hook
            '(lambda ()
               (local-unset-key (kbd "C-.")))))


;; Python
;; python-mode
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-hook 'python-mode-hook '(lambda ()
                               (eldoc-mode -1)
                               (flymake-mode -1)
                               (auto-complete-mode -1)
                               (company-mode 1)))

;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)

; (require 'flymake-python-pyflakes)
; (add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
; (setq flymake-python-pyflakes-executable "flake8")
; (setq flymake-python-pyflakes-extra-arguments '("--max-line-length=100"))

;; ipython
; (setq ipython-command "/usr/local/bin/ipython")
; (require 'ipython)


;; Java
(add-hook 'java-mode-hook
    '(lambda ()
       (gtags-mode 1)))

;; jdee
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/jde/lisp"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/elib"))

; cedit
(require 'cedet)

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


;; rst-mode
(autoload 'rst-mode "rst-mode" "mode for editing reStructuredText documents" t)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))


;;; magit
(use-package magit)

;; forge
(use-package forge
  :after magit)


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
;(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)


;; imenu
(setq imenu-auto-rescan t)
(setq imenu-after-jump-hook (lambda () (recenter 10)))



(use-package git-gutter
  :diminish git-gutter-mode
  :init
  (global-git-gutter-mode t))


;; quickrun
(require 'popwin)
(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
;(global-set-key (kbd "<f5>") 'quickrun)

; To show last line.
(defadvice quickrun/apply-outputter
  (after quickrun/fix-scroll-buffer activate)
  (recenter))


;; dumb-jump
(use-package dumb-jump
  :custom
  (dumb-jump-debug nil)
  :config
  (key-chord-define-global "JB" 'dumb-jump-back)
  (key-chord-define-global "JG" 'dumb-jump-go))


;; symbol-overlay
(require 'symbol-overlay)


;; flycheck
(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'flycheck-mode)
