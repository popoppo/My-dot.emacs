;; eshell
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

(add-hook 'eshell-mode-hook
          (lambda ()
            (key-chord-define-global "UU" '(lambda () (interactive)
                                             (let ((e (point)))
                                               (eshell-bol)
                                               (kill-region (point) e))))
            (auto-complete-mode t)
            (define-key eshell-mode-map (kbd "C-r") 'anything-eshell)))

(use-anything-show-completion 'anything-complete-shell-history
                              '(length anything-c-source-complete-shell-history))

;(when (require 'pcmpl-auto nil t)
;  (when (require 'pcmpl-ssh nil t)
;(add-hook 'eshell-mode-hook 'pcomplete-shell-setup)

(setq eshell-cmpl-ignore-case t)  ; 補完時に大文字小文字を区別しない
(setq eshell-glob-include-dot-dot nil) ; ../ を * でマッチさせない
(setq eshell-ask-to-save-history (quote always)) ; 確認なしでヒストリ保存
(setq eshell-cmpl-cycle-completions t) ; 補完時にサイクルする
(setq eshell-cmpl-cycle-cutoff-length 5) ;補完候補がこの数値以下だとサイクルせずに候補表示
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


;; shell
(when (require 'shell-history nil t)
  (when (require 'anything-complete nil t)
    (add-hook 'shell-mode-hook
              (lambda ()
                (define-key shell-mode-map (kbd "C-r") 'anything-complete-shell-history)))

    (use-anything-show-completion 'anything-complete-shell-history
                                  '(length anything-c-source-complete-shell-history))))

;; ansi-colorでエスケープシーケンスをfontifyする設定
;; http://d.hatena.ne.jp/rubikitch/20081102/1225601754
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
  "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(when (require 'shell-pop nil t)
  (setq shell-pop-window-height 60) ; percentage for shell-buffer window height
  (define-key global-map [(super t)] 'shell-pop))