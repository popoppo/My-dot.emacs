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


(defun my:helm-git-grep-1 (input)
  (when (and helm-git-grep-at-point-deactivate-mark mark-active)
    (deactivate-mark)) ;; remove any active regions
  (helm-git-grep-1 input))

(defun my:extract-fn-name-without-ns (intput)
  (if intput (-> intput
                 (concat " ")
                 (split-string "/")
                 last
                 car)
    ""))

(defun my:helm-git-grep-at-point ()
  (interactive)
  (let* ((symbol (helm-git-grep-get-input-symbol))
         (input (my:extract-fn-name-without-ns symbol)))
    (my:helm-git-grep-1 input)))

(defun my:helm-git-grep-find-defs-at-point ()
  (interactive)
  (let* ((symbol (helm-git-grep-get-input-symbol))
         (target (my:extract-fn-name-without-ns symbol))
         (input (if symbol (concat "def.*\\s" target) target)))
    (my:helm-git-grep-1 input)))

(defun my:helm-git-grep-find-refs-at-point ()
  (interactive)
  (let* ((symbol (helm-git-grep-get-input-symbol))
         (target (my:extract-fn-name-without-ns symbol))
         (input (if symbol (concat "[/(\\s':]" target) "")))
    (my:helm-git-grep-1 input)))

(use-package helm-git-grep
  :requires helm
  ;; :bind (:map helm-map ("C-c g" . helm-git-grep-from-helm)) ;; doesn't work
  :config
  (define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)
  (key-chord-define-global ",g" 'helm-git-grep)
  (key-chord-define-global ",a" 'my:helm-git-grep-at-point)
  (key-chord-define-global ",d" 'my:helm-git-grep-find-defs-at-point)
  (key-chord-define-global ",r" 'my:helm-git-grep-find-refs-at-point)
  ;;(setq helm-git-grep-pathspecs nil)
  (setq helm-git-grep-pathspecs '(":/*" ":!/*test*" ":!/*.idea*" ":!/*yarn.lock" ":!/*.iml" ":!/*externs*")))

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
  (key-chord-define-global "OO" 'helm-swoop)
  (key-chord-define-global "MO" 'helm-multi-swoop))

;; (use-package helm-gtags
;;   :requires helm
;;   )
