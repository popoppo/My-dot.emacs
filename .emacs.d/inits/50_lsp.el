(use-package lsp-mode
  :custom
  (lsp-prefer-flymake 'flymake)
  (lsp-enable-completion-at-point nil)
  ;; ((lsp-inhibit-message t)
  ;;        (lsp-message-project-root-warning t)
  ;;        (create-lockfiles nil))
  :hook   (prog-major-mode . lsp-prog-major-mode-enable))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (scroll-margin 0)
  (lsp-ui-flycheck-enable nil)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-peek-height 20)
  (lsp-ui-peek-list-width 50)
  :hook   (lsp-mode . lsp-ui-mode))

(use-package company-lsp
  ;;:after (lsp-mode company yasnippet)
  :after (lsp-mode company)
  :config (push 'company-lsp company-backends)
  ;; :defines company-backends
  ;; :functions company-backend-with-yas
  ;;:init (cl-pushnew (company-backend-with-yas 'company-lsp) company-backends))
  )

(use-package python-mode
  :config
  (add-hook 'python-mode-hook #'lsp))


;; (lsp-define-stdio-client
;;  lsp-python
;;  "python"
;;  (lambda () default-directory)
;;  '("/Users/koji.takahashi/.pyenv/shims/pyls")
;; 
;;  (add-hook 'prog-major-mode #'lsp-prog-major-mode-enable)
;;   
;;  ;;(add-hook 'python-mode-hook
;;  ;;          (lambda ()
;;  ;;            (lsp-python-enable)))
;;  ;;
;;  ;;(use-package company-lsp
;;  ;;  :config
;;  ;;  (push 'company-lsp company-backends))
;; 
;;  ;; (defun lsp-set-cfg ()
;;  ;;   (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
;;  ;;     ;; TODO: check lsp--cur-workspace here to decide per server / project
;;  ;;     (lsp--set-configuration lsp-cfg)))
;;  ;;
;;  ;; (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)
;;  )

;; (use-package lsp-python
;;   :ensure t)
;; (add-hook 'python-module-hook #'lsp-python-enable)
