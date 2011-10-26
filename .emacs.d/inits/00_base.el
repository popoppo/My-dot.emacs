;; encoding
;(set-default-coding-systems 'euc-jp)
(set-default-coding-systems 'utf-8)


;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))


;; default to better frame titles
(setq frame-title-format (concat "%b"))


;; User profiles
;(setq user-full-name "Koji Takahashi")
;(setq user-mail-address "koji-takahashi@isp.co.jp")


;; Default frame config
(setq default-frame-alist
      (append (list '(width . 100)
                    '(height . 60)
;                    '(font . "-unknown-DejaVu LGC Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
)
              default-frame-alist))


;; Initial settings
(column-number-mode t)
;(display-time)
(ffap-bindings)
;(hide-ifdef-mode)
(iswitchb-mode)
(menu-bar-mode nil)
(set-scroll-bar-mode nil)
(show-paren-mode t)
(tool-bar-mode nil)
(windmove-default-keybindings)
(window-body-height nil)

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq auto-save-default nil)
;(setq case-fold-search nil)
(setq delete-by-moving-to-trash t)
;(setq display-time-24hr-format t)
(setq history-length 1000)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq make-backup-files nil)
(setq next-screen-context-lines 10) ;; for C-v, M-v
;(setq pop-up-windows nil)
(setq ring-bell-function 'ignore)
(setq scroll-step 5) ;; C-n, C-p
(setq transient-mark-mode t)

(setq-default indent-tabs-mode nil)
;(setq-default truncate-lines t)
(setq-default truncate-lines nil)
(setq-default truncate-partial-width-windows t)

;; Backup file dir
(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
    backup-directory-alist))


(require 'cl)

(require 'imenu)

;; ac-mode
;(autoload 'ac-mode "ac-mode" "Minor mode for advanced completion." t nil)

