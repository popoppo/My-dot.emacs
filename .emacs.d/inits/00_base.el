;; encoding
(set-default-coding-systems 'utf-8)


;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))


;; default to better frame titles
(setq frame-title-format (concat "%b"))


;; User profiles
;(setq user-full-name "Koji Takahashi")
;(setq user-mail-address "kj.takahasi@gmail.com")


;; Default frame config
(setq default-frame-alist
      (append (list '(width . 100)
                    '(height . 55)
;                    '(top . 20)
;                    '(left . 1000)
                    '(alpha . 80)
;                    '(alpha . (20 30 50 30))
                    '(font . "-apple-Monaco-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1"))
;                    '(font . "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
              default-frame-alist))

;; Japanese font
(set-fontset-font
 nil 'japanese-jisx0208
;; (font-spec :family "Hiragino Mincho Pro")) ;; font
  (font-spec :family "Hiragino Kaku Gothic ProN")) ;; font

;; Swap command and alt
(setq ns-command-modifier 'meta)
(setq ns-alternate-modifier 'super)

;; Initial settings
(column-number-mode t)
;(display-time)
(ffap-bindings)
;(hide-ifdef-mode)
;; (iswitchb-mode) TO BE DELETED
(menu-bar-mode -1)
(set-scroll-bar-mode nil)
(show-paren-mode t)
(tool-bar-mode -1)
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
(setq scroll-step 1) ;; C-n, C-p
(setq transient-mark-mode t)
;(setq scroll-margin 0)
(setq-default c-basic-offset 4)

(setq-default indent-tabs-mode nil)
;(setq-default truncate-lines t)
;(setq-default truncate-partial-width-windows t)

(add-hook 'shell-mode-hook 'pcomplete-shell-setup)

;; Backup file dir
(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
    backup-directory-alist))


;; recentf
(setq recentf-max-saved-items 1000)
(setq recentf-auto-cleanup 'never)
;; (setq recentf-exclude
;;       '("~/\\.emacs\\.d/recentf"
;;         "/.?TAGS"
;;         "/\\.emacs\\.d/\\.cask/"))
(setq recentf-auto-save-timer
      (run-with-idle-timer 30 t 'recentf-save-list))


;; ac-mode
;(autoload 'ac-mode "ac-mode" "Minor mode for advanced completion." t nil)


;; dired
(setq bookmark-save-flag 1)
(setq dired-listing-switches "-alhF")

;; dired -> dired-x
(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x"))))


(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))


;; desktop (Enable them as needed)
;;(setq history-length 250)
;;(add-to-list 'desktop-globals-to-save 'file-name-history)
;;(setq desktop-globals-to-save '(extended-command-history))
;;(setq desktop-files-not-to-save "")
;;(desktop-save-mode 1)


;; Others
(require 'cl)

(require 'imenu)
