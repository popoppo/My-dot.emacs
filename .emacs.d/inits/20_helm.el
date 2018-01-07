(require 'helm)
(require 'helm-config)

(helm-mode +1)

(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
;(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

; ;; Disable helm in some functions
; (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))

; ;; Emulate `kill-line' in helm minibuffer
; (setq helm-delete-minibuffer-contents-from-point t)
; (defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
;   "Emulate `kill-line' in helm minibuffer"
;   (kill-new (buffer-substring (point) (field-end))))

;; keybindings

;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key (kbd "C-.") 'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)
(key-chord-define-global ";b" 'helm-buffers-list)
(key-chord-define-global ";f" 'helm-find-files)
(key-chord-define-global ";r" 'helm-recentf)
(key-chord-define-global "II" 'helm-imenu)
(key-chord-define-global "qy" 'helm-show-kill-ring)
(key-chord-define-global "qm" 'helm-mark-ring)


(require 'ace-jump-helm-line)
(eval-after-load "helm"
  '(define-key helm-map (kbd "C-'") 'ace-jump-helm-line))
