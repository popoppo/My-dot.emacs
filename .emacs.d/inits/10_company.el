(require 'company)
(global-company-mode)
;;(setq company-idle-delay 0)
;;(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

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

(add-to-list 'company-backends #'company-tabnine)
(global-set-key (kbd "C-M-,") 'company-tabnine)
;; (key-chord-define-global "" ')
