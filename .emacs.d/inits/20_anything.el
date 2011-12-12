;; anything
(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'anything-startup)

(require 'anything)
(require 'anything-config)

;(anything-iswitchb-setup)
;(anything-iswitchb-cancel-anything)

(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "M-p") 'anything-previous-source)
(define-key anything-map (kbd "M-n") 'anything-next-source)
(define-key anything-map (kbd "C-v") 'anything-next-page)
(define-key anything-map (kbd "M-v") 'anything-previous-page)
(define-key anything-find-files-map (kbd "C-k") 'kill-line)
(define-key anything-find-files-map (kbd "C-h C-b") 'undefined)
(define-key anything-find-files-map (kbd "C-h") 'delete-backward-char)

(defun my:anything-ff-switch-to-eshell (candidate)
  "Switch to eshell and cd to `anything-ff-default-directory'."
  (flet ((cd-eshell ()
                    (goto-char (point-max))
                    (insert
                     (format "cd '%s'" anything-ff-default-directory))
                    (eshell-send-input)))
    (if (get-buffer "*eshell*")
        (let ((eshell-window (get-buffer-window "*eshell*")))
          (if eshell-window
              (select-window eshell-window)
            (switch-to-buffer "*eshell*"))
            (cd-eshell))
      (call-interactively 'eshell)
      (cd-eshell))))

(define-anything-type-attribute 'my:file
  `((action
     ("cd on eshell" . (lambda (slct)
                         (setq anything-ff-default-directory
                               (if (file-directory-p slct)
                                   slct
                                 (file-name-directory slct)))
                         (my:anything-ff-switch-to-eshell nil))))
    (persistent-help . "Show this file")
    (action-transformer anything-c-transform-file-load-el
                        anything-c-transform-file-browse-url)
    (candidate-transformer anything-c-w32-pathname-transformer
                           anything-c-skip-current-file
                           anything-c-skip-boring-files
                           anything-c-shorten-home-path))
  "File name.")

; For directory listing.
(defun my:expand-and-remove-tail-slash (lst)
  (mapcar (lambda (elm)
            (replace-regexp-in-string "\\(.+\\)/$" "\\1" (expand-file-name elm)))
          lst))

(defun my:anything-ff-to-eshell ()
  (interactive)
  (let ((dir-src1 (anything-find-files-history :comp-read nil))
        (dir-src2 (progn
                    (set-buffer "*eshell*")
                    (ring-elements eshell-last-dir-ring))))
    (anything-other-buffer
     `((name . "Directory history")
       (candidates . ,(delete-dups (my:expand-and-remove-tail-slash
                                    (append dir-src1 dir-src2))))
       (type . my:file))
     "*anything for dir history*")))

(define-key anything-map (kbd "M-e") (lambda ()
                                       (interactive)
                                       (let ((slct (anything-get-selection)))
                                         (setq anything-ff-default-directory
                                               (if (file-directory-p slct)
                                                   slct
                                                 (file-name-directory slct)))
                                         (anything-ff-run-switch-to-eshell))))
(defun my:cd-to-bmk (slct)
  ;; Check whether an existing bookmark has been specified
  (if (setq filename (cdr (car (bookmark-get-bookmark-record slct))))
      ;; If it points to a directory, change to it.
      (if (file-directory-p filename)
          (progn
            (setq anything-ff-default-directory filename)
            (my:anything-ff-switch-to-eshell filename))
        (error "%s is not a directory" filename))
    (error "%s doesn't exit" filename)))
(anything-c-arrange-type-attribute 'bookmark
  '((action ("cd on eshell" . my:cd-to-bmk)
            REST)))

(setq anything-enable-shortcuts 'prefix)
(define-key anything-map "," 'anything-select-with-prefix-shortcut)

(key-chord-define-global ";c" (lambda ()
                                (interactive)
                                (anything 'anything-c-source-files-in-current-dir)))


;; obsolete??
(defvar my:anything-find-file-additional-sources nil)
(defun my:anything-find-file ()
  "Replacement of `find-file'."
  (interactive)
  (let ((anything-map (anything-read-file-name-map))
        ;; anything-read-file-name-follow-directory uses these variables
        (prompt "Find File: ")
        default-filename require-match predicate
        (additional-attrs '(;; because anything-c-skip-boring-files cannot
                            ;; handle (display . real) candidates
                            (candidate-transformer)
                            (type . file))))
    (anything-other-buffer (append (arfn-sources prompt default-directory
                                                 nil nil nil nil additional-attrs)
                                   my:anything-find-file-additional-sources)
                           "*anything find-file*")))
;;(anything-find-file)

;(key-chord-define-global ";f" 'anything-find-files)
(key-chord-define-global ";f" 'my:anything-find-file)
(key-chord-define-global ";d" 'my:anything-ff-to-eshell)
(key-chord-define-global ";b" 'anything-bookmarks)
(key-chord-define-global ";t" 'anything-gtags-select)
(key-chord-define-global ";r" 'anything-resume)

(global-set-key (kbd "C-.") 'anything-for-files)

;;split-root
;横長のウィンドウを作成
(require 'split-root)
(defvar anything-compilation-window-height-percent 50.0)
(defun anything-compilation-window-root (buf)
 (setq anything-compilation-window
       (split-root-window (truncate (* (window-height)
                                       (/ anything-compilation-window-height-percent
                                          100.0)))))
 (set-window-buffer anything-compilation-window buf))

(setq anything-display-function 'anything-compilation-window-root)
;(anything :source 'anything-c-source-buffers
;          :display-function 'display-buffer-function--split-root)

(require 'recentf-ext)


;;; color-moccur.elの設定
(require 'color-moccur)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))

;;; anything-c-moccurの設定
(require 'anything-c-moccur)
;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
      anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
      anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
      anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする

(key-chord-define-global ";l" 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(key-chord-define-global ";o" 'anything-c-moccur-dmoccur) ;ディレクトリ
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))
