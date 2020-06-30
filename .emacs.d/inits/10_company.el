(require 'company)
(global-company-mode)
;;(setq company-idle-delay 0)
;;(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)
(setq completion-ignore-case t)
;;(setq company-dabbrev-downcase nil)

(global-set-key (kbd "C-M-i") 'company-complete)

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
(define-key company-active-map (kbd "C-i") 'company-complete-selection)

(company-quickhelp-mode t)

(use-package company-tabnine
  :ensure t)

;; (add-to-list 'company-backends #'company-tabnine)
(global-set-key (kbd "C-M-,") 'company-tabnine)
;; (key-chord-define-global "" ')

(set-face-attribute 'company-tooltip nil
            :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
            :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
            :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
            :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
            :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
            :background "grey60")
(set-face-attribute 'company-scrollbar-bg nil
            :background "gray40")
