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
(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.module$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.install$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.engine$" . php-mode))

(add-hook 'php-mode-hook
    '(lambda ()
       (local-unset-key (kbd "C-."))))

;; Python
;; python-mode
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; Pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs"
  '(add-to-list 'pymacs-load-path "~/.emacs.d/pymacs-elisp"))

;; pysmell
(defvar ac-source-pysmell
  '((candidates
     . (lambda ()
         (require 'pysmell)
         (pysmell-get-all-completions))))
  "Source for PySmell")

(add-hook 'python-mode-hook
          '(lambda ()
             ;; (pysmell-mode 1)
             (set (make-local-variable 'ac-sources)
                  (append ac-sources '(ac-source-pysmell)))
             (require 'pymacs)
             ;; Hacks for imenu
             (unless (fboundp 'py-imenu-make-imenu)
               (pymacs-load "py_imenu" "py-imenu-"))
             (setq imenu-create-index-function
                   (lambda ()
                     (let (menu)
                       (message "creating imenu index...")
                       (condition-case nil
                           (setq menu (py-imenu-make-imenu))
                         (error nil
                                (setq menu (py-imenu-create-index-function))))
                       (message "creating imenu index...done")
                       menu))))
          t) ; last 't' means that this func is put on the tail of hooks.

(defadvice py-execute-region (around my-py-execute-region)
  "back to the original buffer when py-execute-region finished."
  (require 'pysmell)
  (if (get-buffer "*Python Output*")
      (kill-buffer "*Python Output*"))
  (let* ((coding-system-for-write buffer-file-coding-system))
    ad-do-it)
  (shrink-window-if-larger-than-buffer)
  (other-window -1))
(ad-enable-advice 'py-execute-region 'around 'my-py-execute-region)
(ad-activate 'py-execute-region)

;; ipython
(setq ipython-command "/usr/local/bin/ipython")
(require 'ipython)

;;(require 'anything-ipython)
;;(when (require 'anything-show-completion nil t)
;;  (use-anything-show-completion 'anything-ipython-complete
;;                                '(length initial-pattern)))
;;(setq ipython-completion-command-string "print ';'.join(__IP.Completer.all_completions('%s')) #PYTHON-MODE SILENT\n")
;;
;;(add-hook 'python-mode-hook #'(lambda ()
;;                                (define-key py-mode-map (kbd "C-'") 'anything-ipython-complete)))
;;(add-hook 'ipython-shell-hook #'(lambda ()
;;                                  (define-key py-mode-map (kbd "C-'") 'anything-ipython-complete)))



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

; cedit
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
(require 'mcomplete)
(turn-on-mcomplete-mode)


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

;; quickrun
(require 'popwin)
(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
;(global-set-key (kbd "<f5>") 'quickrun)

; To show last line.
(defadvice quickrun/apply-outputter
  (after quickrun/fix-scroll-buffer activate)
  (recenter))
