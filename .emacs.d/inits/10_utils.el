;; color-theme
(use-package afternoon-theme
  :straight
  (emacs-afternoon-theme :type git :host github :repo "osener/emacs-afternoon-theme")
  :config
  (load-theme 'afternoon t))

;; windows
(use-package windows
  :straight
  (windows :type git :host github :repo "conao3/emacs-windows.el")
  :config
  (setq win:use-frame nil)
  (win:startup-with-window)
  (define-key ctl-x-map "C" 'see-you-again))

;;auto-insert
(auto-insert-mode 1)
;(setq auto-insert-query nil)

;; dired
(setq bookmark-save-flag 1)
(setq dired-listing-switches "-alhF")

;; dired -> dired-x
(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x"))))

(eval-after-load "dired"
  '(lambda ()
     (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))

(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

(setq dired-dwim-target t)
(setq dired-recursive-copies 'always)

(defun dired-find-alternate-file ()
  "In dired, visit this file or directory instead of the dired buffer."
  (interactive)
  (set-buffer-modified-p nil)
  (find-alternate-file (dired-get-filename)))

(defface my-face-f-2 '((t (:foreground "GreenYellow"))) nil)
(defvar my-face-f-2 'my-face-f-2)
(defun my-dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (concat (format-time-string "%b %e" (current-time)) " [0-9]....") arg t))

(add-hook 'dired-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              major-mode
              (list
               '(my-dired-today-search . my-face-f-2)))))

(use-package bm
  ;; Visble bookmark in buffer
  :disabled)

;; session.el
(use-package session
  :config
  (setq
   session-globals-max-string 10240000
   session-initialize '(de-saveplace session keys menus places)
   session-globals-include '((session-file-alist 500 t)
                             (file-name-history 1000))
   history-length t)
  (add-hook 'after-init-hook 'session-initialize)
  (setq session-undo-check -1))

;;(when (require 'session nil t)
;;  (setq session-initialize '(de-saveplace session keys menus places)
;;        session-globals-include '((kill-ring 50)
;;                                  (session-file-alist 500 t)
;;                                  (file-name-history 10000)))
;;  (add-hook 'after-init-hook 'session-initialize)
;;  ;; 前回閉じたときの位置にカーソルを復帰
;;  (setq session-undo-check -1))

;; thing-opt
;;thingを選択できるようにする
;; (define-prefix-command 'my-own-map)
;; (global-set-key (kbd "C-t") 'my-own-map)
;; 
;; (require 'thing-opt)
;; (define-thing-commands)
;; (define-key 'my-own-map "d" 'mark-defun)
;; (define-key 'my-own-map "w" 'mark-word*)
;; (define-key 'my-own-map "l" 'mark-line)
;; (define-key 'my-own-map "s" 'mark-symbol)
;; (define-key 'my-own-map "e" 'mark-sexp)


;; grep settings
(setq grep-host-defaults-alist nil)
;(setq grep-template "lgrep <C> -n <R> <F> <N>")
;(setq grep-find-template "find . <X> -type f <F> -print0 | sort -z | xargs -0 grep <C> -nH -e <R>")

;; Highlight tab, zenkaku space and space at eol.
;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
;(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defface my-face-u-1 '((t (:foreground "black" :underline t))) nil)
;;(defvar my-face-r-1 'my-face-r-1)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
    '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  :bind
  ("M-/" . undo-tree-redo))

(use-package color-moccur)

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas/initialize)
  (yas/load-directory "~/.emacs.d/snippets"))

;; skk
(straight-use-package
 '(ddskk :type git :host github :repo "skk-dev/ddskk"))
(setq skk-large-jisyo "~/.emacs.d/skk/SKK-JISYO.L")
(defun skk-mode-hook--unset-key ()
  (define-key skk-j-mode-map ";" nil))
(add-hook 'skk-mode-hook 'skk-mode-hook--unset-key)

;; ace-jump-mode
(use-package ace-jump-mode
  :init
  (key-chord-define-global "z." 'ace-jump-mode))

;; jaunte
(use-package jaunte
  :straight
  (jaunte :type git :host github :host "kawaguchi/jaunte")
  :init
  (key-chord-define-global "z/" 'jaunte)
  :config
  (setq jaunte-hint-unit 'whitespace))

(use-package avy
  :straight t
  :config
  (global-set-key (kbd "C-M-;") 'avy-goto-word-1))

;; mark-more-like-thin
(use-package multiple-cursors
  :straight t
  :config
  (key-chord-define-global "za" 'mc/mark-all-like-this)
  (key-chord-define-global "zp" 'mc/mark-previous-like-this)
  (key-chord-define-global "zn" 'mc/mark-next-like-this)
  (key-chord-define-global "zj" 'mc/skip-to-next-like-this)
  (key-chord-define-global "zk" 'mc/skip-to-previous-like-this))

;; expand region
(use-package expand-region
  :straight t
  :config
  (key-chord-define-global "ww" 'er/expand-region)
  (key-chord-define-global "WW" 'er/contract-region))

;; cua-mode
(key-chord-define-global "RR" 'cua-mode) ; R := Rectangle
(setq cua-enable-cua-keys nil)

; from http://d.hatena.ne.jp/kitokitoki/20110305/p2
(defadvice cua-sequence-rectangle (around my-cua-sequence-rectangle activate)
  "連番を挿入するとき、紫のところの文字を上書きしないで左にずらす"
  (interactive
   (list (if current-prefix-arg
             (prefix-numeric-value current-prefix-arg)
           (string-to-number
            (read-string "Start value: (0) " nil nil "0")))
         (string-to-number
          (read-string "Increment: (1) " nil nil "1"))
         (read-string (concat "Format: (" cua--rectangle-seq-format ") "))))
  (if (= (length format) 0)
      (setq format cua--rectangle-seq-format)
    (setq cua--rectangle-seq-format format))
  (cua--rectangle-operation 'clear nil t 1 nil
                            '(lambda (s e l r)
                               (kill-region s e)
                               (insert (format format first))
                               (yank)
                               (setq first (+ first incr)))))


;; Full screen
(defvar my-fullscreen-default 'fullboth)
(defun my-fullscreen (arg)
  (interactive "P")
  (let* ((state (frame-parameter (selected-frame) 'fullscreen))
         (my-fullscreen-default
          (intern (completing-read (format "method (now:%s): " state)
                                     '("fullboth" "maximized" "nil")
                                     nil
                                     t))))
    (cond
     ((or arg (null state))
      (setq state my-fullscreen-default))
     (t
      (setq state nil)))
    (set-frame-parameter (selected-frame) 'fullscreen state))
  (redisplay))
(global-set-key (kbd "C-`") 'my-fullscreen)

;; Generate new buffer and switch to it
(defun create-buffer (buf)
  (interactive "Bbuff:")
  (switch-to-buffer (get-buffer-create buf)))

;; Get value of default-directory in current buffer
(defun get-default-directory ()
  (interactive)
  (message default-directory)
  (kill-new default-directory))

(use-package smooth-scroll
  :diminish smooth-scroll-mode
  :config
  (smooth-scroll-mode t))

(use-package lispxmp)

(defun company-look (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-look))
    (prefix (when (looking-back "\\w+" nil t)
               (match-string 0)))
    (candidates (let ((cmd (format "look %s" arg)))
                   (with-temp-buffer
                     (call-process-shell-command cmd nil t)
                     (split-string-and-unquote (buffer-string) "\n"))))
    (meta (format "Looking %s" arg))))

(global-set-key (kbd "C-M-l") 'company-look)
;;(key-chord-define-global "??" 'company-look)


;; visual-regexp
(use-package visual-regexp
  :disabled
  :config
  (key-chord-define-global "qw" 'vr/query-replace))


;; if you use multiple-cursors, this is for you:
;(define-key global-map (kbd "C-c m") 'vr/mc-mark)


(use-package foreign-regexp
  :disabled
  :custom
  (foreign-regexp/regexp-type 'perl)
  (reb-re-syntax 'foreign-regexp))


(use-package docker-tramp-compat
  :straight
  (docker-tramp-compat :type git :host github :repo "emacs-pe/docker-tramp.el"))


(use-package emojify
  :straight t
  :hook (after-init . global-emojify-mode))
  ;;:hook (after-init . global-emojify-mode)
