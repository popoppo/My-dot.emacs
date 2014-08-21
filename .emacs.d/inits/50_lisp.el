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

;; For completion
(add-to-list 'ac-modes 'scheme-mode)
(add-to-list 'ac-modes 'gauche-mode)

;(autoload 'scheme-smart-complete "scheme-complete" nil t)
;(eval-after-load 'scheme
;  '(define-key scheme-mode-map (kbd "C-,") 'scheme-smart-complete))

;; scheme-mode-hook
(defvar ac-source-scheme
  '((candidates
     . (lambda ()
         (require 'scheme-complete)
         (all-completions ac-target (car (scheme-current-env))))))
  "Source for scheme keywords.")
(add-hook 'scheme-mode-hook
          '(lambda ()
             (make-local-variable 'ac-sources)
             (setq ac-sources (append ac-sources '(ac-source-scheme)))))
