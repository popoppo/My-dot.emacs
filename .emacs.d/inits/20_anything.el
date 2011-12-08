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

(define-anything-type-attribute 'my:file
  `((action
     ("cd on eshell" . (lambda (slct)
                         (setq anything-ff-default-directory
                               (if (file-directory-p slct)
                                   slct
                                 (file-name-directory slct)))
                         (anything-ff-switch-to-eshell nil))))
    (persistent-help . "Show this file")
    (action-transformer anything-c-transform-file-load-el
                        anything-c-transform-file-browse-url)
    (candidate-transformer anything-c-w32-pathname-transformer
                           anything-c-skip-current-file
                           anything-c-skip-boring-files
                           anything-c-shorten-home-path))
  "File name.")

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
            (anything-ff-switch-to-eshell filename))
        (error "%s is not a directory" filename))
    (error "%s doesn't exit" filename)))
(anything-c-arrange-type-attribute 'bookmark
  '((action ("cd on eshell" . my:cd-to-bmk)
            REST)))

(setq anything-enable-shortcuts 'prefix)
(define-key anything-map "," 'anything-select-with-prefix-shortcut)

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

(key-chord-define-global ";f" 'anything-find-files)
(key-chord-define-global ";d" 'my:anything-ff-to-eshell)
(key-chord-define-global ";b" 'anything-bookmarks)


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