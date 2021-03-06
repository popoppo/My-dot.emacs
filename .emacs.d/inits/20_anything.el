;; anything
(add-to-list 'load-path "~/.emacs.d/auto-install")
(require 'anything-startup)

(require 'anything)
(require 'anything-config)

(anything-iswitchb-setup)
;(anything-iswitchb-cancel-anything)

(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "M-p") 'anything-previous-source)
(define-key anything-map (kbd "M-n") 'anything-next-source)
;(define-key anything-map (kbd "C-v") 'anything-next-source)
;(define-key anything-map (kbd "M-v") 'anything-previous-source)


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
