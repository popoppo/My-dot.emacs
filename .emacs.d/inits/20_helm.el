(use-package helm
  :diminish
  :ensure t
  :config
  (helm-mode 1)
  (key-chord-define-global ";b" 'helm-buffers-list)
  (key-chord-define-global ";f" 'helm-find-files)
  (key-chord-define-global ";r" 'helm-recentf)
  (key-chord-define-global "II" 'helm-imenu)
  (key-chord-define-global "qy" 'helm-show-kill-ring)
  (key-chord-define-global "qm" 'helm-mark-ring)
  :bind (("C-." . helm-mini)
         ("M-x" . 'helm-M-x)
         :map helm-map
         ("C-h" . delete-backward-char)
         :map helm-find-files-map
         ("C-h" . delete-backward-char)))

;(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

; ;; Disable helm in some functions
; (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))

; ;; Emulate `kill-line' in helm minibuffer
; (setq helm-delete-minibuffer-contents-from-point t)
; (defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
;   "Emulate `kill-line' in helm minibuffer"
;   (kill-new (buffer-substring (point) (field-end))))

(use-package helm-ag
  :requires helm
  :config
  (setq helm-ag-command-option "--hidden") ;; For dot files and dirs
  (key-chord-define-global "a;" 'helm-ag))

(use-package helm-git-grep
  :requires helm
  :config
  (key-chord-define-global "g;" 'helm-git-grep)
  :bind
  (:map helm-map
   ("C-c g" . helm-git-grep-from-helm)))

;; helm-git-grep
;; Invoke `helm-git-grep' from isearch.
;; (define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
;; (eval-after-load 'helm
;;   '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

(use-package ace-jump-helm-line
  :requires helm
  :bind
  (:map helm-map
   ("C-'" . ace-jump-helm-line)))

;; (require 'ace-jump-helm-line)
;; (eval-after-load "helm"
;;   '(define-key helm-map (kbd "C-'") 'ace-jump-helm-line))


;; helm-ls-git
(use-package helm-ls-git
  :requires helm
  :config
  (key-chord-define-global ";l" 'helm-ls-git-ls))

;;(require 'helm-ls-git)
;;(key-chord-define-global ";l" 'helm-ls-git-ls)

(use-package helm-swoop
  :requires helm
  :config
  (key-chord-define-global "OO" 'helm-swoop))
