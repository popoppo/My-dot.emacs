(use-package company
  :straight t
  :config
  (setq company-selection-wrap-around t)
  (setq completion-ignore-case t)
  (global-company-mode)
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
  :bind (("C-," . company-complete)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ("C-s" . company-filter-candidates)
         ("C-i" . company-complete-selection)))

(use-package company-quickhelp
  :straight t
  :config
  (company-quickhelp-mode t))

(use-package company-tabnine
  ;; :config
  ;; (add-to-list 'company-backends #'company-tabnine)
  :bind
  ("C-M-," . company-tabnine))
