;; color-theme
;; Use /usr/share/emacs/site-lisp or /usr/share/emacs/site-lisp/goodies if exists.
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-resolve)))

;; windows
(require 'windows)
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)


;;dmacro.el
(defconst *dmacro-key* "\C-t" "\C-t")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)


;;auto-insert
;(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-directory "~/.emacs.d/lisp/insert/")
(auto-insert-mode 1)
;(setq auto-insert-query nil)

(setq auto-insert-alist
      (append '(("\\.h" . "template-header-cpp.txt"))
              auto-insert-alist))

;;Redo
(require 'redo)
(global-set-key "\M-/" 'redo)


;;move buffer by C-. C-,
;(load-file "/home/takahashi/.emacs.d/site-lisp/move-buffer.el")


;; for dired
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
               '(my-dired-today-search . my-face-f-2)
            ))))



;; Visble bookmark in buffer
(require 'bm)


;; psvn.el
(require 'psvn)


;; session.el
;kill-ringやミニバッファで過去に開いたファイルなどの履歴を保存する
(when (require 'session nil t)
  (setq session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 50)
                                  (session-file-alist 500 t)
                                  (file-name-history 10000)))
  (add-hook 'after-init-hook 'session-initialize)
  ;; 前回閉じたときの位置にカーソルを復帰
  (setq session-undo-check -1))


;; minibuf-isearch
;minibufでisearchを使えるようにする
(require 'minibuf-isearch nil t)


;; icicles
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/icicles"))
(load "icicles")


;; thing-opt
;thingを選択できるようにする
(define-prefix-command 'my-own-map)
(global-set-key (kbd "C-t") 'my-own-map)

(require 'thing-opt)
(define-thing-commands)
(define-key 'my-own-map "w" 'mark-word*)
(define-key 'my-own-map "l" 'mark-line)
(define-key 'my-own-map "s" 'mark-symbol)


;; own util
(defun create-seq ()
 (interactive)
 (let ((index (string-to-number (read-from-minibuffer "Init:" )))
       (ub (string-to-number (read-from-minibuffer "Upper bound:" )))
       (separator (read-from-minibuffer "Seprator:")))
   (if (string-equal separator "") (setq separator "\n"))
   (while (<= index ub)
     (insert (format "%d%s" index separator))
     (setq index (1+ index)))))


(defadvice kill-region (around kill-word-or-kill-region activate)
      (if (and (interactive-p) transient-mark-mode (not mark-active))
          (backward-kill-word 1)
        ad-do-it))

(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)

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

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; ac-mode
;(autoload 'ac-mode "ac-mode" "Minor mode for advanced completion." t nil)

;; auto-complete
(add-to-list 'load-path "~/.emacs.d/site-lisp/auto-complete")
(require 'auto-complete)
(global-auto-complete-mode t)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/dict")
(require 'auto-complete-config)
(ac-config-default)

(setq ac-use-menu-map t)

;; color-moccur
(require 'color-moccur)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/site-lisp/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/site-lisp/yasnippet/snippets")

;; skk
(load "skk")
(require 'skk-autoloads)
(setq skk-large-jisyo
      (expand-file-name "~/.emacs.d/site-lisp/skk/SKK-JISYO.L"))
(setq Info-default-directory-list
      (cons "~/.emacs.d/site-lisp/skk/info" Info-default-directory-list))
(setq skk-tut-file
      (expand-file-name "~/.emacs.d/site-lisp/skk/SKK.tut"))

;; +x
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)


;; other window
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(global-set-key (kbd "C-=") 'other-window-or-split)


;; ace-jump-mode
(require 'ace-jump-mode)
(key-chord-define-global "z." 'ace-jump-mode)

;; jaunte
(require 'jaunte)
(key-chord-define-global "z," 'jaunte)
(setq jaunte-hint-unit 'whitespace)

;; point-undo
(require 'point-undo)
;(define-key global-map [f7] 'point-undo)
;(define-key global-map [S-f7] 'point-redo)
(key-chord-define-global "z[" 'point-undo)
(key-chord-define-global "z]" 'point-redo)

;; srep
(require 'srep)
