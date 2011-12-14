(require 'smartchr)
(defun my-move-to-window-line (arg)
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

;;remove backword in mini buffer
(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)

(global-unset-key "\C-x\C-b")
(global-unset-key "\C-x\C-c")
(global-set-key "\C-x\C-f" 'anything-find-file)
;(global-set-key "\C-x\C-f" 'anything-find-files)
;(global-set-key (kbd "=") (smartchr '(" = " "=" " == " "==")))
;(global-set-key (kbd "-") (smartchr '("-" "_")))
(global-set-key "\M-p" '(lambda () (interactive) (next-line -4)))
(global-set-key "\M-n" '(lambda () (interactive) (next-line 4)))
(global-set-key "\M-m" 'just-one-space)
(global-set-key "\C-a" '(lambda () (interactive)
                          (let ((beginning 0))
                            (save-excursion
                              (beginning-of-line)
                              (setq beginning (point)))
                            (cond ((= (point) beginning)
                                   (search-forward-regexp "^[ \t]*[^ \t]")
                                   (backward-char))
                                  (t
                                   (beginning-of-line))))))

(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key [?\C-\;] 'dabbrev-expand)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key (kbd "C-,") 'auto-complete)
;(global-set-key "\C-c\C-z" 'suspend-frame)
(global-set-key "\C-x\C-c\C-k" 'kill-buffer-and-window)
(global-set-key "\C-x\C-c\C-z" 'kill-emacs)
;(global-set-key [?\C-,] '(lambda () (interactive)
;                           (let ((lines (lines-from-top (point))))
;                             (move-to-window-line (ceiling (/ lines 2))))))
;(global-set-key [?\C-.] '(lambda () (interactive)
;                           (let ((current-pos (point))
;                                 (tail-pos 0)
;                                 (lft (lines-from-top (point)))
;                                 (lines 0))
;                             (save-excursion
;                               (move-to-window-line -1)
;                               (setq tail-pos (point)))
;                             (setq lines (count-lines current-pos tail-pos))
;                             (move-to-window-line (+ lft
;                                                     (ceiling (/ lines 2)))))))
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\M-q" 'query-replace-regexp)
(global-set-key "\C-xrp" 'string-insert-rectangle)
(global-set-key "\C-cm" 'compile)
;          ("\C-c\C-t" (lambda () (interactive)
;                       (insert (format-time-string "%H:%M:%S"))))
(global-set-key "\M-h" '(lambda () (interactive)
                                 (backward-char)
                                 (forward-whitespace -1)
                                 (forward-char)))
;(global-set-key "\M-h" '(lambda (arg)
;                          (interactive "cChar:")
;                          (search-backward-regexp (char-to-string arg))
;                          (message "%s" (char-to-string arg))
;                          (while (eq (read-event) ?n)
;                            (message "%s" (char-to-string arg))
;                            (search-backward-regexp (char-to-string arg)))))
(global-set-key "\M-j" '(lambda () (interactive)
                          (set-mark-command 0)))
(global-set-key "\M-l"  'forward-whitespace)
;(global-set-key "\M-l"  '(lambda (arg)
;                           (interactive "cChar:")
;                           (search-forward-regexp (char-to-string arg))
;                           (backward-char)
;                           (message "%s" (char-to-string arg))
;                           (while (eq (read-event) ?n)
;                             (message "%s" (char-to-string arg))
;                             (forward-char)
;                             (search-forward-regexp (char-to-string arg))
;                             (backward-char))))
(global-set-key "\M-r" 'my-move-to-window-line)


(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.3)
;;(key-chord-define-global "bl" '(lambda () (interactive)
;;                                 (let ((l (read-from-minibuffer "")))
;;                                   (forward-line (- (string-to-number l))))))
;;(key-chord-define-global "fl" '(lambda () (interactive)
;;                                 (let ((l (read-from-minibuffer "")))
;;                                   (forward-line (string-to-number l)))))
(key-chord-define-global "ql" 'anything-show-kill-ring)
(key-chord-define-global "BB" '(lambda () (interactive)
                                 (backward-char)
                                 (forward-whitespace -1)
                                 (forward-char)))
(key-chord-define-global "FF" 'forward-whitespace)
(key-chord-define-global "KS" 'kill-sexp)
(key-chord-define-global "KK" '(lambda () (interactive)
                                 (beginning-of-line)
                                 (kill-line)
                                 (delete-char 1)))
(key-chord-define-global "AA" 'beginning-of-buffer)
(key-chord-define-global "EE" 'end-of-buffer)
(key-chord-define-global "II" 'anything-imenu)
(key-chord-define-global "gl" 'goto-line)
;(key-chord-define-global "ff" 'find-file-at-point)
;(key-chord-define-global "jf" 'anything-for-files)
(key-chord-define-global "QQ" 'skk-mode)
;(global-set-key "¥C-x¥C-j" 'skk-mode)
;(global-set-key "¥C-xj" 'skk-auto-fill-mode)
;(global-set-key "¥C-xt" 'skk-tutorial)
(key-chord-define-global "MS" 'start-kbd-macro)
(key-chord-define-global "ME" 'end-kbd-macro)
;(key-chord-define-global "ll" 'recenter-top-bottom)
(key-chord-define-global "qn" '(lambda () (interactive)
                                 (next-line 1)
                                 (let ((p1 0) (p2 0))
                                   (save-excursion
                                     (search-forward-regexp "^[ \n\t]*$")
                                     (setq p1 (point)))
                                   (save-excursion
                                     (search-forward-regexp "[^ \n\t]")
                                     (beginning-of-line)
                                     (setq p2 (point)))
                                   (if (> p1 p2)
                                       (goto-char p1)
                                       (goto-char p2)))))
(key-chord-define-global "qp" '(lambda () (interactive)
                                 (previous-line 1)
                                 (let ((p1 0) (p2 0))
                                   (save-excursion
                                     (search-backward-regexp "^[ \n\t]*$")
                                     (setq p1 (point)))
                                   (save-excursion
                                     (search-backward-regexp "[^ \n\t]")
                                     (beginning-of-line)
                                     (setq p2 (point)))
                                   (if (< p1 p2)
                                       (goto-char p1)
                                       (goto-char p2)))))
(key-chord-define-global "NN" 'forward-sexp)
(key-chord-define-global "PP" 'backward-sexp)
(key-chord-define-global "qq" 'toggle-view-mode)
(key-chord-define-global "qw" 'query-replace-regexp)
(key-chord-define-global "UU" '(lambda () (interactive)
                                 (let ((e (point)))
                                   (beginning-of-line)
                                   (kill-region (point) e))))
(key-chord-define-global "yy" '(lambda () (interactive)
                                 (save-excursion
                                   (beginning-of-line)
                                   (let ((b (point))
                                         (saved next-line-add-newlines))
                                     ;;(setq next-line-add-newlines 1)
                                     (next-line)
                                     ;;(setq next-line-add-newlines saved)
                                     (let ((e (point)))
                                       (clipboard-kill-ring-save b e))))))
;(key-chord-define-global "zz" '(lambda () (interactive) (repeat nil)))


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
     (define-key skk-j-mode-map sticky-key sticky-map)
     (define-key skk-jisx0208-latin-mode-map sticky-key sticky-map)
     (define-key skk-abbrev-mode-map sticky-key sticky-map)))
(eval-after-load "skk-isearch"
  '(define-key skk-isearch-mode-map sticky-key sticky-map))