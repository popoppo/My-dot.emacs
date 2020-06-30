(defun my:move-to-window-line (arg)
  (interactive "P")
  (if (not (null arg))
      (move-to-window-line arg)
    (let ((here (point))
          (top 0)
          (mid 0))
      (save-excursion
        (move-to-window-line 0)
        (setq top (point)))
      (save-excursion
        (move-to-window-line nil)
        (setq mid (point)))
      (cond ((= here top)
             (move-to-window-line (- 1)))
            ((= here mid)
             (move-to-window-line 0))
            (t
             (move-to-window-line nil))))))

(defun toggle-view-mode ()
  (interactive)
  (cond (view-mode
         (view-mode 0)
         (setq hl-line-mode nil))
        (t
         (view-mode 1))))

;; mykie
(require 'mykie)
(setq mykie:use-major-mode-key-override t)
(mykie:initialize)
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
  :region     clipboard-kill-ring-save)


;; remove backword in mini buffer
(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)


(global-unset-key "\C-x\C-c")
;;(global-set-key "\M-m" 'just-one-space)
(global-set-key "\C-a" '(lambda () (interactive)
                          (let ((beginning 0))
                            (save-excursion
                              (beginning-of-line)
                              (setq beginning (point)))
                            (cond ((= (point) beginning)
                                   (back-to-indentation))
                                  (t
                                   (beginning-of-line))))))
;;(global-set-key "\M-a" '(lambda () (interactive) (command-execute (kbd "C-M-a"))))
;;(global-set-key "\M-e" '(lambda () (interactive) (command-execute (kbd "C-M-e"))))
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key [?\C-\;] 'hippie-expand)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key (kbd "C-,") 'auto-complete) ;; TODO: move to ?
(global-set-key "\C-x\C-c\C-k" 'kill-buffer-and-window)
(global-set-key "\C-x\C-c\C-z" 'kill-emacs)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\M-q" 'query-replace-regexp)
(global-set-key "\C-xrp" 'string-insert-rectangle)
(global-set-key "\M-h" 'backward-kill-word)
(global-set-key "\M-l" '(lambda () (interactive)
                          (set-mark-command 0)))
;;(global-set-key "\M-r" 'my:move-to-window-line)
(global-set-key (kbd "C-\\") 'mark-word)


(defun my:with-mark (func)
  (interactive)
  (push-mark nil)
  (funcall func))


(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.3)
(key-chord-define-global "qh" '(lambda () (interactive)
                                 (backward-char)
                                 (forward-whitespace -1)
                                 (forward-char)))
(key-chord-define-global "ql" 'forward-whitespace)
(key-chord-define-global "SK" 'kill-sexp)
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
(key-chord-define-global "GL" 'goto-line)
(key-chord-define-global "HS" 'hs-minor-mode)
(key-chord-define-global "HX" 'hs-toggle-hiding)
(key-chord-define-global "QQ" 'skk-mode)
;(global-set-key "¥C-x¥C-j" 'skk-mode)
;(global-set-key "¥C-xj" 'skk-auto-fill-mode)
;(global-set-key "¥C-xt" 'skk-tutorial)
(key-chord-define-global "MS" 'start-kbd-macro)
;;(key-chord-define-global "ME" 'end-kbd-macro)
;(key-chord-define-global "ll" 'recenter-top-bottom)
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
;;(key-chord-define-global "qq" 'toggle-view-mode)
(key-chord-define-global "qw" 'query-replace-regexp)
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
(key-chord-define-global "`n" 'flycheck-next-error)
(key-chord-define-global "`p" 'flycheck-previous-error)
(key-chord-define-global "GN" 'git-gutter:next-hunk)
(key-chord-define-global "GP" 'git-gutter:previous-hunk)

;; Sticky Shift
(defvar sticky-key "'")
(defvar sticky-list
  '(("a" . "A")("b" . "B")("c" . "C")("d" . "D")("e" . "E")("f" . "F")("g" . "G")
    ("h" . "H")("i" . "I")("j" . "J")("k" . "K")("l" . "L")("m" . "M")("n" . "N")
    ("o" . "O")("p" . "P")("q" . "Q")("r" . "R")("s" . "S")("t" . "T")("u" . "U")
    ("v" . "V")("w" . "W")("x" . "X")("y" . "Y")("z" . "Z")
    ("1" . "!")("2" . "@")("3" . "#")("4" . "$")("5" . "%")("6" . "^")("7" . "&")
    ("8" . "*")("9" . "(")("0" . ")")
    ("`" . "~")("[" . "{")("]" . "}")("-" . "_")("=" . "+")("," . "<")("." . ">")
    ("/" . "?")(";" . ":")("'" . "\"")("\\" . "|")
    ))
(defvar sticky-map (make-sparse-keymap))
(define-key global-map sticky-key sticky-map)
(mapcar (lambda (pair)
          (define-key sticky-map (car pair)
            `(lambda()(interactive)
               (setq unread-command-events
                     (cons ,(string-to-char (cdr pair)) unread-command-events)))))
        sticky-list)
(define-key sticky-map sticky-key '(lambda ()(interactive)(insert sticky-key)))

(eval-after-load "skk"
  '(progn
     (key-chord-define skk-latin-mode-map "jj" 'skk-kakutei)
     (key-chord-define skk-j-mode-map ">>" '(lambda () (interactive) (insert ".")))
     (key-chord-define skk-j-mode-map "<<" '(lambda () (interactive) (insert ",")))
     (define-key skk-j-mode-map sticky-key sticky-map)
     (define-key skk-jisx0208-latin-mode-map sticky-key sticky-map)
     (define-key skk-abbrev-mode-map sticky-key sticky-map)))
(eval-after-load "skk-isearch"
  '(define-key skk-isearch-mode-map sticky-key sticky-map))


;; wdired
(eval-after-load "dired"
  '(lambda ()
     (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))
