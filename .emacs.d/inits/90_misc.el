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


(require 'uniquify)
(setq-default uniquify-min-dir-content 1)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


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
;(require 'w3m-load)

;; For dired
(setq dired-listing-switches "-alh")

(defun dired-my-advertised-find-file ()
  (interactive)
  (let ((kill-target (current-buffer))
        (check-file (dired-get-filename)))
    (funcall 'dired-advertised-find-file)
    (if (file-directory-p check-file)
        (kill-buffer kill-target))))

(defun dired-my-up-directory (&optional other-window)
  "Run dired on parent directory of current directory.
Find the parent directory either in this buffer or another buffer.
Creates a buffer if necessary."
  (interactive "P")
  (let* ((dir (dired-current-directory))
         (up (file-name-directory (directory-file-name dir))))
    (or (dired-goto-file (directory-file-name dir))
        ;; Only try dired-goto-subdir if buffer has more than one dir.
        (and (cdr dired-subdir-alist)
             (dired-goto-subdir up))
        (progn
          (if other-window
              (dired-other-window up)
            (progn
              (kill-buffer (current-buffer))
              (dired up))
          (dired-goto-file dir))))))

(define-key dired-mode-map "\C-m" 'dired-my-advertised-find-file)
(define-key dired-mode-map "^" 'dired-my-up-directory)

;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

(define-key dired-mode-map "o" '(lambda ()
                                  (interactive)
                                  (popwin:find-file (dired-get-file-for-visit))))
(add-to-list 'popwin:special-display-config '("\*Man \*" :regexp t :height 30))
(add-to-list 'popwin:special-display-config '("\*IPython Completions\*"))

;; For markdown
(setq markdown-command "markdown2")

;; Move to other window when a window is split.
(defadvice split-window-vertically (after my-move-after-split-window)
  (other-window 1))

(defadvice split-window-horizontally (after my-move-after-split-window)
  (other-window 1))

(ad-activate 'split-window-vertically 'my-move-after-split-window)
(ad-activate 'split-window-horizontally 'my-move-after-split-window)

;; direx
(require 'direx)
(require 'popwin)
;(setq direx:leaf-icon "  "
;      direx:open-icon "- "
;      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 30 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
