; pukiwiki mode
;(add-to-list load-path "~/.emacs.d/site-lisp/apel")
;(load "pukiwiki-mode")
;(setq pukiwiki-auto-insert t)
;(autoload 'pukiwiki-edit
;  "pukiwiki-mode" "pukwiki-mode." t)
;(autoload 'pukiwiki-index
;  "pukiwiki-mode" "pukwiki-mode." t)
;(autoload 'pukiwiki-edit-url
;  "pukiwiki-mode" "pukwiki-mode." t)
;(setq
; pukiwiki-site-list
; '(("local"
;    "http://localhost/~takahashi/pukiwiki/"
;    nil utf-8)
;))


;(add-to-list 'load-path "~/.emacs.d/site-lisp/howm/")
;(setq howm-menu-lang 'ja)
;(global-set-key "\C-c,," 'howm-menu)
;(mapc
; (lambda (f)
;   (autoload f
;     "howm" "Hitori Otegaru Wiki Modoki" t))
; '(howm-menu howm-list-all howm-list-recent
;             howm-list-grep howm-create
;             howm-keyword-to-kill-ring))


; (require 'uniquify)
; (setq-default uniquify-min-dir-content 1)
; (setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;; keisen
(global-set-key [C-right] 'keisen-right-move )
(global-set-key [C-left] 'keisen-left-move )
(global-set-key [C-up] 'keisen-up-move )
(global-set-key [C-down] 'keisen-down-move )
(autoload 'keisen-up-move "keisen" nil t)
(autoload 'keisen-down-move "keisen" nil t)
(autoload 'keisen-left-move "keisen" nil t)
(autoload 'keisen-right-move "keisen" nil t)


;; markdown-mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.text" . markdown-mode) auto-mode-alist))

;; w3m
(require 'w3m-load)
