;;; .emacs

(setq ns-function-modifier 'hyper)  ; map fn key to hyper

;; Adding /usr/local/bin and ~/bin
(if (not (string-match "\\(^\\|:\\)/usr/local/bin\\($\\|\\:\\)" (getenv "PATH")))
    (setenv "PATH" (concat '"/usr/local/bin:" (getenv "PATH"))))
(if (not (member "/usr/local/bin" exec-path))
    (setq exec-path (cons "/usr/local/bin" exec-path)))
(setenv "PATH" (concat '"~/bin:" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/bin"))

;; Using straight.el for package management
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package compatibility
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; ログはエラーが出た時のみ
;;(custom-set-variables '(init-loader-show-log-after-init 'error-only))

;; INSTALL
(use-package init-loader)
(init-loader-load (expand-file-name "~/.emacs.d/inits"))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/local/org/gtd.org" "~/local/org/notes.org")))
 '(org-agenda-include-diary nil)
 '(org-agenda-ndays 7)
 '(org-agenda-repeating-timestamp-show-all t)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-window-setup (quote other-window))
 '(org-babel-load-languages (quote ((emacs-lisp . t) (mscgen . t))))
 '(org-deadline-warning-days 7)
 '(org-export-html-table-tag "<table border=\"2\" cellspacing=\"0\" cellpadding=\"6\" frame=\"hsides\"> <!--rules=\"groups\" -->")
 '(org-fast-tag-selection-single-key nil)
 '(org-insert-mode-line-in-empty-file t)
 '(org-log-done (quote (done)))
 '(org-refile-targets (quote (("gtd.org" :maxlevel . 1) ("archive.org" :maxlevel . 1))))
 '(org-reverse-note-order nil)
 '(org-tags-match-list-sublevels t)
 '(org-time-stamp-rounding-minutes (list 5))
 '(org-timeline-show-empty-dates t)
 '(org-use-fast-todo-selection t)
 '(session-use-package t nil (session))
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-face-highlight-textual ((t (:inherit highlight :background "gray60")))))
