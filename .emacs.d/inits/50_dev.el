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


;; C/C++
(add-hook 'c-mode-hook
    '(lambda ()
       ;(gtags-make-complete-list)))
       (gtags-mode 1)
       (gtags-make-complete-list)))

(add-hook 'c++-mode-hook
    '(lambda ()
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
(use-package python-mode
  :config
  (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
  (setq interpreter-mode-alist (cons '("python" . python-mode)
                                     interpreter-mode-alist))
  (add-hook 'python-mode-hook '(lambda ()
                                 (eldoc-mode -1)
                                 (flymake-mode -1)
                                 (auto-complete-mode -1)
                                 (company-mode 1)))
  (add-hook 'python-mode-hook #'lsp))

;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)

; (require 'flymake-python-pyflakes)
; (add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
; (setq flymake-python-pyflakes-executable "flake8")
; (setq flymake-python-pyflakes-extra-arguments '("--max-line-length=100"))

;; ipython
; (setq ipython-command "/usr/local/bin/ipython")
; (require 'ipython)


;; rst-mode
(autoload 'rst-mode "rst-mode" "mode for editing reStructuredText documents" t)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))


;;; magit
(use-package magit
  :straight t)

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
(use-package popwin
  :straight t)
(use-package quickrun
  :straight t
  :config
  (push '("*quickrun*") popwin:special-display-config))

; To show last line.
(defadvice quickrun/apply-outputter
  (after quickrun/fix-scroll-buffer activate)
  (recenter))


;; dumb-jump
(use-package dumb-jump
  :custom
  (dumb-jump-debug nil)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; symbol-overlay
(use-package symbol-overlay
  :straight t)

;; flycheck
(use-package flycheck
  :straight t
  :hook (emacs-lisp-mode . flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
;; (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

;; yaml-mode
(use-package yaml-mode
  :straight t
  :mode ("\\.ya?ml\\'" . yaml-mode))

(use-package restclient
  :straight t)
