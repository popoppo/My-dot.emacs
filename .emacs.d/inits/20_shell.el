;; eshell
(setq password-cache t)
(setq password-cache-expiry 600) ;; sec

; Handle escape sequency properly.
(require 'ansi-color)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'eshell-mode-hook 'ansi-color-for-comint-mode-on)

;;(defun eshell-handle-ansi-color ()
;;  (ansi-color-apply-on-region eshell-last-output-start
;;                              eshell-last-output-end))
;;(add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)


; Open eshell on current directory
(defun eshell-cd-default-directory ()
  (interactive)
  (let ((dir default-directory))
    (eshell)
    (cd dir)
    (eshell-interactive-print (concat "cd " dir "\n"))
    (eshell-emit-prompt)))
;(key-chord-define-global "EO" 'eshell-cd-default-directory)
(key-chord-define-global "EO" '(lambda () (interactive)
                                 (if (require 'shell-pop nil t)
                                     (let ((dir default-directory)
                                           (shl shell-pop-internal-mode-shell))
                                       (shell-pop-set-internal-mode "eshell")
                                       (shell-pop)
                                       (cd dir)
                                       (eshell-interactive-print (concat "cd " dir "\n"))
                                       (eshell-emit-prompt)
                                       (setq shell-pop-internal-mode-shell shl))
                                     eshell-cd-default-directory)))

; Command line stack
(defvar *eshell-command-stack* nil
  "Command line stack")
(make-variable-buffer-local '*eshell-command-stack*)

(defun eshell-push-command (cmd)
  "Add cmd to command line stack"
  (interactive
   (let ((str (progn
                (eshell-bol)
                (buffer-substring (point) (point-max)))))
     (delete-region (point) (point-max))
     (list str)))
  (unless (equal cmd "")
    (push cmd *eshell-command-stack*)))

;(defadvice eshell-send-input (after esh-pop-com activate)
;  (when *eshell-command-stack*
;    (insert (pop *eshell-command-stack*))))

(defun eshell-pop-command ()
  (interactive)
  (when *eshell-command-stack*
    (insert (pop *eshell-command-stack*))))

(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key "\M-q" 'eshell-push-command)
            (local-set-key "\M-e" 'eshell-pop-command)))

; defvars
(defvar anything-c-eshell-directory-history
  '((name . "Directory History")
    (candidates . (lambda ()
                    (set-buffer "*eshell*")
                    (delete-dups (ring-elements eshell-last-dir-ring))))
    (action . (("Change Directory" . anything-eshell-change-directory)))))

(defvar anything-c-eshell-command-history
  '((name . "Command History")
    (candidates . (lambda ()
                    (set-buffer "*eshell*")
                    (remove-if (lambda (str) (string-match "^cd *" str))
                               (delete-dups (ring-elements eshell-history-ring)))))
    (action . (("Insert" . insert))))) ;; この行をコメントアウトして次の行を使う手もあるが
    ;; (action . (("Execute" . anything-eshell-exec-command))))) ;; 使わないほうが無難

(defun anything-eshell-change-directory (dir)
  (insert (concat "cd " dir))
  (eshell-send-input))

;; (defun anything-eshell-exec-command (command)
;;   (insert command)
;;   (eshell-send-input))

(defun anything-eshell ()
  (interactive)
  (anything
   (list
    anything-c-eshell-command-history
    anything-c-eshell-directory-history
    anything-c-source-files-in-current-dir+
    anything-c-source-recentf
    anything-c-source-buffers+
    anything-c-source-bookmarks
    )))

;(when (require 'pcmpl-auto nil t)
;  (when (require 'pcmpl-ssh nil t)
;(add-hook 'eshell-mode-hook 'pcomplete-shell-setup)

(require 'pcomplete)
(add-to-list 'ac-modes 'eshell-mode)

(ac-define-source pcomplete
  '((candidates . pcomplete-completions)))

(defun my-ac-eshell-mode ()
  (setq ac-sources
        '(ac-source-pcomplete
          ac-source-words-in-buffer
          ac-source-dictionary)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (key-chord-define eshell-mode-map "UU" '(lambda () (interactive)
                                             (let ((e (point)))
                                               (eshell-bol)
                                               (kill-region (point) e))))
;            (auto-complete-mode t)
            (my-ac-eshell-mode)
            (define-key eshell-mode-map (kbd "C-o") 'anything-eshell)))

(use-anything-show-completion 'anything-complete-shell-history
                              '(length anything-c-source-complete-shell-history))


(setq eshell-cmpl-ignore-case t)  ; 補完時に大文字小文字を区別しない
(setq eshell-glob-include-dot-dot nil) ; ../ を * でマッチさせない
(setq eshell-ask-to-save-history (quote always)) ; 確認なしでヒストリ保存
(setq eshell-cmpl-cycle-completions nil) ; 補完時にサイクルする
(setq eshell-cmpl-cycle-cutoff-length 1) ;補完候補がこの数値以下だとサイクル
;  (setq eshell-history-file-name "~/.zsh_history") ; zsh のヒストリと共有
(setq eshell-history-size 10000)                ; ヒストリサイズ
(setq eshell-last-dir-ring-size 1000)
(setq eshell-hist-ignoredups t)      ; ヒストリの重複を無視

(defadvice eshell-send-input (after eshell-send-input-after-advice)
  (eshell-save-some-history)
  (eshell-save-some-last-dir))

(ad-activate 'eshell-send-input)

;; prompt文字列の変更
(setq eshell-prompt-function
      (lambda ()
        (concat
         "["
         (format-time-string "%H:%M " (current-time))
         (user-login-name) "@" (system-name) " "
         (eshell/pwd)
         (if (= (user-uid) 0) "]\n# " "]\n$ "))))
(setq eshell-prompt-regexp "^[^#$]*[$#] ")

;(defun pcomplete/sudo ()
;  "Completion rules for the `sudo' command."
;  (let ((pcomplete-help "complete after sudo"))
;    (pcomplete-here (pcomplete-here (eshell-complete-commands-list)))))
(defalias 'pcomplete/sudo 'pcomplete/xargs)

;; eshell/bmk - version 0.1.3
(defun pcomplete/eshell-mode/bmk ()
  "Completion for `bmk'"
  (pcomplete-here (bookmark-all-names)))

(defun eshell/bmk (&rest args)
  "Integration between EShell and bookmarks.
For usage, execute without arguments."
  (setq args (eshell-flatten-list args))
  (let ((bookmark (car args))
        filename name)
    (cond
     ((eq nil args)
      (format "Usage:
* bmk BOOKMARK to
** either change directory pointed to by BOOKMARK
** or bookmark-jump to the BOOKMARK if it is not a directory.
* bmk . BOOKMARK to bookmark current directory in BOOKMARK.
Completion is available."))
     ((string= "." bookmark)
      ;; Store current path in EShell as a bookmark
      (if (setq name (car (cdr args)))
          (progn
            (bookmark-set name)
            (bookmark-set-filename name (eshell/pwd))
            (format "Saved current directory in bookmark %s" name))
        (error "You must enter a bookmark name")))
     (t
       ;; Check whether an existing bookmark has been specified
       (if (setq filename (cdr (car (bookmark-get-bookmark-record bookmark))))
           ;; If it points to a directory, change to it.
           (if (file-directory-p filename)
               (eshell/cd filename)
             ;; otherwise, just jump to the bookmark
             (bookmark-jump bookmark))
         (error "%s is not a bookmark" bookmark))))))


;; shell
(when (require 'shell-history nil t)
  (when (require 'anything-complete nil t)
    (add-hook 'shell-mode-hook
              (lambda ()
                (define-key shell-mode-map (kbd "C-r") 'anything-complete-shell-history)))

    (use-anything-show-completion 'anything-complete-shell-history
                                  '(length anything-c-source-complete-shell-history))))

;; Term
(require 'term)
(global-set-key "\C-ct" '(lambda ()(interactive)(ansi-term "/bin/bash")))

(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          (function
           (lambda ()
             (define-key term-raw-map "\C-ct"
               '(lambda ()(interactive)(ansi-term "/bin/bash"))))))

(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)


(add-hook 'term-mode-hook '(lambda ()
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
                               (lookup-key (current-global-map) "\C-z"))))


;; ansi-colorでエスケープシーケンスをfontifyする設定
;; http://d.hatena.ne.jp/rubikitch/20081102/1225601754
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
  "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(define-key global-map "\C-cp" '(lambda () (interactive)
                                  (when (require 'shell-pop nil t)
                                    (cond
                                     ((or (equal (buffer-name) shell-pop-internal-mode-buffer)
                                            (equal (buffer-name) "*eshell*"))
                                        (shell-pop))
                                     (t
                                      (shell-pop-set-internal-mode "ansi-term")
                                      (shell-pop-set-internal-mode-shell "/bin/bash")
                                      (setq shell-pop-window-height 30)
                                      (shell-pop))))))

;; Toggle term-char-mode/term-line-mode
(key-chord-define-global ",," '(lambda () (interactive)
                                 (if (string= "Term" mode-name)
                                     (if (term-in-char-mode)
                                         (term-line-mode)
                                       (term-char-mode)))))
