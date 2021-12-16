(defun toggle-view-mode ()
  (interactive)
  (cond (view-mode
         (view-mode 0)
         (setq hl-line-mode nil))
        (t
         (view-mode 1))))

;; mykie
(use-package mykie
  :config
  (mykie:initialize)
  (setq mykie:use-major-mode-key-override t)
  (mykie:set-keys nil
  "H"
  :default    self-insert-command
  :region     symbol-overlay-put
  :region-handle-flag copy

  "O"
  :default    self-insert-command
  :region     helm-occur
  :region-handle-flag copy

  "S"
  :default    self-insert-command
  :region     isearch-forward
  :region-handle-flag copy

  "W"
  :default    self-insert-command
  :region     kill-region

  "Y"
  :default    self-insert-command
  :region     clipboard-kill-ring-save))


(global-unset-key "\C-x\C-c")
(global-set-key "\C-a" (lambda () (interactive)
                         (if (bolp)
                             (back-to-indentation)
                           (beginning-of-line))))
;;(global-set-key "\M-a" '(lambda () (interactive) (command-execute (kbd "C-M-a"))))
;;(global-set-key "\M-e" '(lambda () (interactive) (command-execute (kbd "C-M-e"))))
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
;;(global-set-key [?\C-\;] 'hippie-expand)
(global-set-key [?\C-\;] 'dabbrev-expand)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-x\C-c\C-k" 'kill-buffer-and-window)
(global-set-key "\C-x\C-c\C-z" 'kill-emacs)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-xrp" 'string-insert-rectangle)
;; (global-set-key "\M-h" 'backward-kill-word)
(global-set-key "\M-l" '(lambda () (interactive)
                          (set-mark-command 0)))
(global-set-key (kbd "C-\\") 'mark-word)
(global-set-key "\M-gt" '(lambda ()
                           (interactive)
                           (my:with-mark 'beginning-of-buffer)))
(global-set-key "\M-gb" '(lambda ()
                           (interactive)
                           (my:with-mark 'end-of-buffer)))
(global-set-key "\M-gl" 'forward-whitespace)
(global-set-key "\M-gh" '(lambda ()
                           (interactive)
                           (forward-whitespace -1)))
(global-set-key (kbd "C-=") '(lambda (c)
                               (interactive "cChar:")
                               (search-forward-regexp (char-to-string c))))
(global-set-key (kbd "M-[") 'backward-paragraph)
(global-set-key (kbd "M-]") 'forward-paragraph)

(defun my:with-mark (func)
  (interactive)
  (push-mark nil)
  (funcall func))

(use-package key-chord
  :straight t
  :config
  (key-chord-mode t)
  (setq key-chord-two-keys-delay 0.3))

(key-chord-define-global "QH" '(lambda () (interactive)
                                 (backward-char)
                                 (forward-whitespace -1)
                                 (forward-char)))
(key-chord-define-global "QL" 'forward-whitespace)
;;(key-chord-define-global "KS" 'kill-sexp)
(key-chord-define-global "KK" '(lambda () (interactive)
                                 (beginning-of-line)
                                 (kill-line)
                                 (delete-char 1)))
(key-chord-define-global "AA" '(lambda ()
                                 (interactive)
                                 (my:with-mark 'beginning-of-buffer)))
(key-chord-define-global "EE" '(lambda ()
                                 (interactive)
                                 (my:with-mark 'end-of-buffer)))
(key-chord-define-global "JJ" '(lambda ()
                                 (interactive)
                                 (delete-indentation 1)))
(key-chord-define-global "MM" 'just-one-space)
(key-chord-define-global "HS" 'hs-minor-mode)
(key-chord-define-global "HX" 'hs-toggle-hiding)
(key-chord-define-global "QQ" 'skk-mode)
;(global-set-key "¥C-xj" 'skk-auto-fill-mode)
;(global-set-key "¥C-xt" 'skk-tutorial)
(key-chord-define-global "MS" 'start-kbd-macro)
;;(key-chord-define-global "ME" 'end-kbd-macro)
(key-chord-define-global "MD" 'mark-defun)
(key-chord-define-global "qn" '(lambda () (interactive)
                          (next-line 1)
                          (let ((p1 0) (p2 0))
                            (save-excursion
                              (search-forward-regexp "^[ \t]*$")
                              (setq p1 (point)))
                            (save-excursion
                              (search-forward-regexp "[^ \t\n]")
                              (beginning-of-line)
                              (setq p2 (point)))
                            (if (> p1 p2)
                                (goto-char p1)
                              (goto-char p2)))))
(key-chord-define-global "qp" '(lambda () (interactive)
                          (previous-line 1)
                          (let ((p1 0) (p2 0))
                            (save-excursion
                              (search-backward-regexp "^[ \t]*$")
                              (setq p1 (point)))
                            (save-excursion
                              (search-backward-regexp "[^ \t\n]")
                              (beginning-of-line)
                              (setq p2 (point)))
                            (if (< p1 p2)
                                (goto-char p1)
                              (goto-char p2)))))
(key-chord-define-global "q=" '(lambda () (interactive)
                                 (search-forward-regexp "= *")))
(key-chord-define-global "q-" '(lambda () (interactive)
                                 (search-forward-regexp "_")))
(key-chord-define-global "q9" '(lambda () (interactive)
                                 (search-forward-regexp "\(")))
(key-chord-define-global "q0" '(lambda () (interactive)
                                 (search-forward-regexp ")")))
(key-chord-define-global "q," '(lambda () (interactive)
                                 (search-forward-regexp ",")))
(key-chord-define-global "q." '(lambda () (interactive)
                                 (search-forward-regexp ".")))
;;(key-chord-define-global "MA" 'mark-sexp)
(key-chord-define-global "NL" '(lambda () (interactive)
                                 (next-line)
                                 (beginning-of-line)
                                 (open-line 1)))
(key-chord-define-global "NP"  '(lambda () (interactive)
                                  (next-line)
                                  (beginning-of-line)
                                  (open-line 1)
                                  (yank)))
(key-chord-define-global "SD" 'down-list)
(key-chord-define-global "SN" 'forward-list)
(key-chord-define-global "SP" 'backward-list)
(key-chord-define-global "SU" 'backward-up-list)
(key-chord-define-global "SW" 'window-configuration-to-register)
(key-chord-define-global "VV" 'toggle-view-mode)
(key-chord-define-global "QW" 'query-replace-regexp)
(key-chord-define-global "UU" '(lambda () (interactive)
                                 (let ((e (point)))
                                   (beginning-of-line)
                                   (kill-region (point) e))))
(key-chord-define-global "YD" 'get-default-directory)
(key-chord-define-global "YY" '(lambda () (interactive)
                                 (save-excursion
                                   (beginning-of-line)
                                   (let ((b (point))
                                         (saved next-line-add-newlines))
                                     (next-line)
                                     (let ((e (point)))
                                       (clipboard-kill-ring-save b e))))))
;;(key-chord-define-global "`n" 'flycheck-next-error)
;;(key-chord-define-global "`p" 'flycheck-previous-error)
(key-chord-define-global "GN" 'git-gutter:next-hunk)
(key-chord-define-global "GP" 'git-gutter:previous-hunk)
(key-chord-define-global "BM" 'bookmark-jump)
(key-chord-define-global "LC" 'lsp-execute-code-action)
(key-chord-define-global "LD" 'lsp-find-definition)
(key-chord-define-global "LR" 'lsp-find-references)
