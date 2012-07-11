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
  (eshell-kill-input)
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

;; aliases
(add-to-list 'eshell-command-aliases-list (list "la" "ls -a $1"))
(add-to-list 'eshell-command-aliases-list (list "ll" "ls -l $1"))
(add-to-list 'eshell-command-aliases-list (list "fw" "find-file $1"))
(add-to-list 'eshell-command-aliases-list (list "fw" "find-file-other-window $1"))

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
(add-to-list 'ac-modes 'term-mode)

(global-set-key "\C-ct" '(lambda ()(interactive)(ansi-term "/bin/bash")))

(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          '(lambda ()
             (define-key term-raw-map "\C-ct"
               '(lambda ()(interactive)(ansi-term "/bin/bash")))))

(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)


(add-hook 'term-mode-hook '(lambda ()
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
               (ansi-term-write-last-dir-ring)))
        ))
    ad-do-it
    (cond ((string= cmd "cd")
           (sit-for 0.01)
           (ansi-term-add-to-dir-ring default-directory));TODO "cd abc;echo var"
          )))
;(ad-remove-advice 'term-send-raw 'around 'my:term-send-raw)
;(ad-deactivate 'term-send-raw)
(ad-activate 'term-send-raw 'my:term-send-raw)

(defun ansi-term-add-to-dir-ring (path)
  "Add PATH to the last-dir-ring, if applicable."
  (unless (and (not (ring-empty-p ansi-term-last-dir-ring))
               (equal path (ring-ref ansi-term-last-dir-ring 0)))
    (let ((index 0)
          (len (ring-length ansi-term-last-dir-ring)))
      (while (< index len)
        (if (equal (ring-ref ansi-term-last-dir-ring index) path)
            (ring-remove ansi-term-last-dir-ring index)
          (setq index (1+ index))))))
  (ring-insert ansi-term-last-dir-ring path))

(defun ansi-term-write-last-dir-ring ()
  "Write the buffer's `ansi-term-last-dir-ring' to a history file."
  (let ((file ansi-term-last-dir-ring-file-name))
    (cond
     ((or (null file)
          (equal file "")
          (null ansi-term-last-dir-ring)
          (ring-empty-p ansi-term-last-dir-ring))
      nil)
     ((not (file-writable-p file))
      (message "Cannot write last-dir-ring file %s" file))
     (t
      (let* ((ring ansi-term-last-dir-ring)
             (index (ring-length ring)))
        (with-temp-buffer
          (while (> index 0)
            (setq index (1- index))
            (insert (ring-ref ring index) ?\n))
          ;; (insert (ansi-term/pwd) ?\n)
          ;; (ansi-term-with-private-file-modes
           (write-region (point-min) (point-max) file nil
                         'no-message)))))))
;)
(add-hook 'kill-emacs-hook 'ansi-term-write-last-dir-ring)
;(remove-hook 'kill-emacs-hook 'ansi-term-write-last-dir)

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

;; (defadvice ac-expand (around my:term-ac)
;;   (let ((is-changed nil))
;;     (when (and
;;            (string= "Term" mode-name)
;;            (term-in-char-mode))
;;       (term-line-mode)
;;       (setq is-changed t))
;;     ad-do-it
;;     (let (b e s)
;;       (term-bol nil)
;;       (setq b (point))
;;       (setq e (point-at-eol))
;;       (setq s (buffer-substring-no-properties b e))
;;       (if is-changed
;;           (term-char-mode))
;;       (term-send-raw-string "")
;;       (term-send-raw-string "")
;;       (term-send-raw-string "")
;;       (term-send-raw-string s)
;;       )))
;; (ad-activate 'ac-expand 'my:term-ac)

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
;(ad-remove-advice 'ac-complete 'around 'my:term-ac)
;(ad-deactivate 'ac-expand)


(defvar ansi-term-last-dir-ring)
(setq ansi-term-last-dir-ring (make-ring 32))
;(unless ansi-term-last-dir-ring
;  (setq ansi-term-last-dir-ring (make-ring 32)))

(defvar ansi-term-last-dir-ring-file-name
  (expand-file-name "lastdir" "~/.myterm"))


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
                             (if ansi-term-last-dir-ring-file-name
                                 (ansi-term-read-last-dir-ring))
                             (define-key term-raw-map "\M-q" 'my:ansi-term-push-commnad)
                             (define-key term-raw-map "\M-e" 'my:ansi-term-pop-commnad)
                             ;;
                             ))

(defun ansi-term-read-last-dir-ring ()
  "Set the buffer's `ansi-term-last-dir-ring' from a history file."
  (let ((file ansi-term-last-dir-ring-file-name))
    (cond
     ((or (null file)
      (equal file "")
      (not (file-readable-p file)))
      nil)
     (t
      (let* ((count 0)
         (size 32)
         (ring (make-ring size)))
    (with-temp-buffer
      (insert-file-contents file)
      ;; Save restriction in case file is already visited...
      ;; Watch for those date stamps in history files!
      (goto-char (point-max))
      (while (and (< count size)
              (re-search-backward "^\\([^\n].*\\)$" nil t))
        (ring-insert-at-beginning ring (match-string 1))
        (setq count (1+ count)))
      ;; never allow the top element to equal the current
      ;; directory
      ;; (while (and (not (ring-empty-p ring))
      ;;             (equal (ring-ref ring 0) (eshell/pwd)))
      ;;   (ring-remove ring 0))
      )
    (setq ansi-term-last-dir-ring ring))))))

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
