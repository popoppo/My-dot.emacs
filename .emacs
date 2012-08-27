;; .emacs

;; load-path
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install"))
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic/bovine") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/semantic/wisent") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/common") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/cedet/eieio") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/jde/lisp") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/elib") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/skk") t)
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/site-lisp/python-mode") t)
(add-to-list 'load-path
             "~/.emacs.d/site-lisp/mark-multiple.el") ; dir
(add-to-list 'load-path
             "~/.emacs.d/site-lisp/expand-region.el") ; dir
(add-to-list 'load-path
             "~/.emacs.d/site-lisp/multiple-cursors.el") ; dir

(setq exec-path (append exec-path '(expand-file-name "~/bin")))

;; INSTALL
(require 'init-loader)
(setq init-loader-show-log-after-init nil)
(init-loader-load (expand-file-name "~/.emacs.d/inits"))

;; 00 ... Basic configration.
;; 10 ... Pre-execution, environment constraction, and utilites.
;; 50 ... Development tools.
;; 90 ... Misc tools and funcs.
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ac-auto-start nil)
 '(ac-ignores nil)
 '(ac-use-fuzzy t)
 '(bookmark-save-flag 1)
 '(default-tab-width 4 t)
 '(ipython-complete-use-separate-shell-p nil)
 '(jde-ant-enable-find t)
 '(jde-ant-home "/usr/local/dev/ant")
 '(jde-ant-program "/usr/local/dev/ant/bin/ant" t)
 '(jde-ant-working-directory "")
 '(jde-compile-option-classpath nil)
 '(jde-gen-final-arguments nil)
 '(jde-gen-final-methods nil)
 '(jde-jdk-registry (quote (("1.5" . "/usr/local/java/jdk-1.5"))))
 '(org-agenda-files (quote ("~/Dropbox/org/gtd.org" "~/Dropbox/org/notes.org")))
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
 '(org-deadline-warning-days 7)
 '(org-fast-tag-selection-single-key nil)
 '(org-insert-mode-line-in-empty-file t)
 '(org-log-done (quote (done)))
 '(org-refile-targets (quote (("gtd.org" :maxlevel . 1) ("archive.org" :maxlevel . 1))))
 '(org-reverse-note-order nil)
 '(org-tags-match-list-sublevels t)
 '(org-time-stamp-rounding-minutes 5)
 '(org-timeline-show-empty-dates t)
 '(org-use-fast-todo-selection t)
 '(pcomplete-cycle-completions nil)
 '(pcomplete-cycle-cutoff-length 1)
 '(py-complete-function nil)
 '(py-imenu-create-index-p t)
 '(py-indent-no-completion-p nil)
 '(tab-width 4))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(eshell-prompt ((t (:foreground "White" :weight bold)))))

(add-hook 'after-init-hook '(lambda () (interactive) (ansi-term "/bin/bash")))
