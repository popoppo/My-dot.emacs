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
;(define-key anything-find-files-map (kbd "C-h C-b") 'undefined)
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


(defun my:upto-parent-dir ()
  (interactive)
  (declare (special prompt default-filename require-match predicate additional-attrs))
  (setq arfn-followed t)
  (let* ((sel "../")
         (f (expand-file-name sel arfn-dir)))
    (cond ((and (file-directory-p f) (not (string-match "/\\.$" sel)))
           (with-selected-window (minibuffer-window) (delete-minibuffer-contents))
           (setq anything-pattern "")
           ;;(setq arfn-dir f)
           (anything-set-sources
            (my:arfn-sources
             prompt f default-filename require-match nil predicate additional-attrs))
           (anything-update)))))
(defun my:anything-read-file-name-follow-directory ()
  (interactive)
  (declare (special prompt default-filename require-match predicate additional-attrs))
  (setq arfn-followed t)
  (let* ((sel (anything-get-selection))
         (f (expand-file-name sel arfn-dir)))
    (cond ((and (file-directory-p f) (not (string-match "/\\.$" sel)))
           (with-selected-window (minibuffer-window) (delete-minibuffer-contents))
           (setq anything-pattern "")
           ;;(setq arfn-dir f)
           (anything-set-sources
            (my:arfn-sources
             prompt f default-filename require-match nil predicate additional-attrs))
           (anything-update))
          ((string-match "^\\(.+\\)/\\([^/]+\\)$" sel)
           (with-selected-window (minibuffer-window)
             (delete-minibuffer-contents)
             (insert (match-string 2 sel)))
           (anything-set-sources
            (my:arfn-sources
             prompt (expand-file-name (match-string 1 sel) arfn-dir) nil require-match (match-string 2 sel) predicate additional-attrs))
           (anything-update)))))

;; obsolete??
(defun* my:arfn-sources (prompt dir default-filename require-match initial-input predicate &optional (additional-attrs '((action . identity))))
  (setq arfn-dir dir)
  (let* ((dir (or dir default-directory))
         (transformer-func
          (if predicate
              `(candidate-transformer
                . (lambda (cands)
                    (remove-if-not
                     (lambda (c) (,predicate (if (consp c) (cdr c) c))) cands)))))
;         (new-input-source (ac-new-input-source
;                            prompt nil
;                            (append '((display-to-real . (lambda (f) (expand-file-name f arfn-dir))))
;                                    additional-attrs)))
         (history-source (unless require-match
                           `((name . "History")
                             (candidates . file-name-history)
                             (persistent-action . find-file)
                             ,@additional-attrs))))
    `(((name . "Default")
       (candidates . ,(if default-filename (list default-filename)))
       (persistent-action . find-file)
       (filtered-candidate-transformer
        . (lambda (cands source)
            (if (and (not arfn-followed) (string= anything-pattern "")) cands nil)))
       (display-to-real . (lambda (f) (expand-file-name f ,dir)))
       ,@additional-attrs)
      ((name . ,dir)
       (candidates . (lambda () (arfn-candidates ,dir)))
       (persistent-action . find-file)
       ,@additional-attrs
       ,transformer-func)
;      ,new-input-source
      ,history-source)))

(defun my:anything-smart-exit-minibuffer ()
  "Select the current candidate by exiting the minibuffer."
  (interactive)
  (declare (special anything-iswitchb-candidate-selected))
  (let ((sel (anything-get-selection)))
    (if (file-directory-p sel)
        (my:anything-read-file-name-follow-directory)
      (setq anything-iswitchb-candidate-selected sel)
      (exit-minibuffer))))

(defun my:anything-smart-exit-minibuffer1 (sel)
  "Select the current candidate by exiting the minibuffer."
  (interactive)
  (declare (special anything-iswitchb-candidate-selected))
  (if (file-directory-p sel)
      (my:anything-read-file-name-follow-directory)
    (setq anything-iswitchb-candidate-selected sel)
    (exit-minibuffer)))

(define-anything-type-attribute 'my:find-file
  `((action
     ("Open file or goto dir" . my:anything-smart-exit-minibuffer1)
    (persistent-help . "Show this file")
    (action-transformer anything-c-transform-file-load-el
                        anything-c-transform-file-browse-url)
    (candidate-transformer anything-c-w32-pathname-transformer
                           anything-c-skip-current-file
                           anything-c-skip-boring-files
                           anything-c-shorten-home-path))
  "File name."))

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
                            (type . my:find-file))))
    (define-key anything-map (kbd "C-.") 'my:upto-parent-dir)
    (define-key anything-map (kbd "C-i") 'my:anything-read-file-name-follow-directory)
    (define-key anything-map (kbd "<tab>") 'my:anything-read-file-name-follow-directory)
    (define-key anything-map (kbd "<RET>") 'my:anything-smart-exit-minibuffer)
    (anything-other-buffer  (my:arfn-sources prompt
                                             default-directory
                                             nil nil nil nil additional-attrs)
                           "*anything find-file*")))
;;(anything-find-file)

;(key-chord-define-global ";f" 'anything-find-files)
(key-chord-define-global ";f" 'my:anything-find-file)
(key-chord-define-global ";d" 'my:anything-ff-to-eshell)
(key-chord-define-global ";b" 'anything-bookmarks)
(key-chord-define-global ";t" 'anything-gtags-select)
(key-chord-define-global ";r" 'anything-resume)

(defun my:_switch-window (window file)
  (let*((window (or window
                    (if (< last-command-char 0)
                        (- last-command-char ?\M-0)
                      (- last-command-char win:base-key))))
        (wc (aref win:configs window)))
    (if (aref win:configs window)
        ;;if target window already exists.
        (progn
          (win:switch-window window)
          (find-file file))
      ;;if target window does not exist.
      (win:switch-window window nil t)
      (delete-other-windows)
      (switch-to-buffer (get-buffer-create "*scratch*"))
      (sit-for 0)
      (find-file file))))

(defun my:switch-window ()
  (interactive)
  (let ((num (read-from-minibuffer "Window number: "))
        (file (read-file-name "Find file on new window: ")))
    (my:switch-window (string-to-int num) file)))

(key-chord-define-global ";w" 'my:switch-window)
(anything-c-arrange-type-attribute 'file
  '((action REST
            ("open in other window(with widonws.el)" .
             (lambda (slct)
               (let ((num (read-from-minibuffer "Window number: ")))
                 (my:_switch-window (string-to-int num) (concat default-directory slct))))))))
(anything-c-arrange-type-attribute 'buffer
  '((action REST
            ("open in other window(with widonws.el)" .
             (lambda (slct)
               (let ((num (read-from-minibuffer "Window number: ")))
                 (my:_switch-window (string-to-int num) (concat default-directory slct))))))))

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

;;; キーバインドの割当(好みに合わせて設定してください)
(key-chord-define-global ";l" 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(key-chord-define-global ";o" 'anything-c-moccur-dmoccur) ;ディレクトリ
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))
