;; eshell
(setq password-cache t)
(setq password-cache-expiry 600) ;; sec

; Handle escape sequency properly.
(require 'ansi-color)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'eshell-mode-hook 'ansi-color-for-comint-mode-on)

;; Term
(require 'term)
;;(add-to-list 'ac-modes 'term-mode)

(global-set-key "\C-ct" '(lambda () (interactive)
                           (ansi-term "/bin/bash")))

(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          '(lambda ()
             (define-key term-raw-map "\C-ct"
               '(lambda () (interactive)
                  (ansi-term "/bin/bash")))))

(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)


;(add-hook 'term-mode-hook '(lambda ()
; hook for parsing command and arguments.
(defadvice term-send-raw (around my:term-send-raw)
  (sit-for 0.01) ; For time-lag
  (let ((keys (this-command-keys))
        cmd)
    (when (string= keys "")
      (term-bol nil)
      (let* ((cmd-line (buffer-substring (point) (point-at-eol)))
             (items (split-string cmd-line)))
        (setq cmd (car items))
        (cond ((string= cmd "exit")
               (ansi-term-write-last-dir-ring)))))
    ad-do-it
    (cond ((string= cmd "cd")
           (sit-for 0.01)
           (ansi-term-add-to-dir-ring default-directory)))))
;(ad-remove-advice 'term-send-raw 'around 'my:term-send-raw)
;(ad-deactivate 'term-send-raw)
(ad-activate 'term-send-raw 'my:term-send-raw)


(defadvice dabbrev-expand (after my:term-ac)
  (when (string= "Term" mode-name)
    (let ((is-changed nil))
      (when (term-in-char-mode)
        (term-line-mode)
        (setq is-changed t))
      (let (b e s)
        (term-bol nil)
        (setq b (point))
        (setq e (point-at-eol))
        (setq s (buffer-substring-no-properties b e))
        (if is-changed
            (term-char-mode))
        (term-send-raw-string "")
        (term-send-raw-string "")
        (term-send-raw-string "\e1") ; 1 has no meanings, but re-draw only current line.
        (term-send-raw-string "")
        (term-send-raw-string s)
        ))))
;(ad-remove-advice 'dabbrev-expand 'after 'my:term-ac)
;(ad-deactivate 'dabbrev-expand)
(ad-activate 'dabbrev-expand 'my:term-ac)

(defadvice ac-complete (around my:term-ac)
  (let ((is-changed nil))
    (when (and
           (string= "Term" mode-name)
           (term-in-char-mode))
      (term-line-mode)
      (setq is-changed t))
    ad-do-it
    (let (b e s)
      (term-bol nil)
      (setq b (point))
      (setq e (point-at-eol))
      (setq s (buffer-substring-no-properties b e))
      (if is-changed
          (term-char-mode))
      (term-send-raw-string "")
      (term-send-raw-string "")
      (term-send-raw-string "\e1")
      (term-send-raw-string "")
      (term-send-raw-string s)
      )))
(ad-activate 'ac-complete 'my:term-ac)
;(ad-deactivate 'ac-expand)


(defvar *my:ansi-command-stack* nil
  "Command line stack")
(make-variable-buffer-local '*my:ansi-command-stack*)

(defun my:ansi-term-push-commnad ()
  (interactive)
  (term-bol nil)
  (let ((cmd (buffer-substring-no-properties (point) (point-at-eol))))
    (unless (equal cmd "")
      (push cmd *my:ansi-command-stack*)
      (message (car *my:ansi-command-stack*))
      (term-send-raw-string "")
      (term-send-raw-string "")
      (term-send-raw-string "\e1")
      (term-send-raw-string ""))))

(defun my:ansi-term-pop-commnad ()
  (interactive)
  (unless (null *my:ansi-command-stack*)
    (let ((cmd (pop *my:ansi-command-stack*)))
      (term-send-raw-string cmd))))


(add-hook 'term-mode-hook '(lambda ()
                             (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
                             (define-key term-raw-map "\C-y" 'term-paste)
;                             (define-key term-raw-map "\C-q" 'move-beginning-of-line)
;                             (define-key term-raw-map "\C-r" 'term-send-raw)
;                             (define-key term-raw-map "\C-s" 'term-send-raw)
;                             (define-key term-raw-map "\C-f" 'forward-char)
;                             (define-key term-raw-map "\C-b" 'backward-char)
;                             (define-key term-raw-map "\C-t" 'set-mark-command)
;                             (define-key term-raw-map (kbd "ESC") 'term-send-raw)
;                             (define-key term-raw-map [delete] 'term-send-raw)
                             (define-key term-raw-map "\C-cp" 'shell-pop)
                             (define-key term-raw-map (kbd "M-x") 'nil)
;                             (define-key term-raw-map (kbd "C-w") 'nil)
                             (define-key term-raw-map (kbd "C-k")
                               (lambda (&optional arg) (interactive "P")
                                 (funcall 'kill-line arg) (term-send-raw)))
                             (define-key term-raw-map "\C-z"
                               (lookup-key (current-global-map) "\C-z"))
                             ;;
                             (define-key term-raw-map "\M-q" 'my:ansi-term-push-commnad)
                             (define-key term-raw-map "\M-e" 'my:ansi-term-pop-commnad)
                             ;;
                             ))


;; ansi-colorでエスケープシーケンスをfontifyする設定
;; http://d.hatena.ne.jp/rubikitch/20081102/1225601754
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
  "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; shell-pop
(use-package shell-pop
  :custom
  ;;(shell-pop-default-directory "~")
  (shell-pop-full-span t)
  (shell-pop-shell-type
   (quote ("ansi-term" "*ansi-term*"
           (lambda nil
             (ansi-term shell-pop-term-shell)))))
  (shell-pop-term-shell "/bin/bash")
  (shell-pop-universal-key "C-c p")
  (shell-pop-window-position "bottom")
  (shell-pop-window-size 30)
  :config
  (key-chord-define-global ",," '(lambda () (interactive)
                                   (if (string= "Term" mode-name)
                                       (if (term-in-char-mode)
                                           (term-line-mode)
                                         (term-char-mode))))))
