;; Org mode
(require 'org-install)

;; (save-window-excursion (shell-command (format "emacs-test -l test-minimum -l %s %s &" buffer-file-name buffer-file-name)))
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-directory "~/Dropbox/org/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(setq org-capture-templates
      `(("t" "Todo" entry
         (file+headline ,(concat org-directory "gtd.org") "TODO")
         "** %? %t")
;        ("w" "Work" entry
;         (file+headline "~/local/org/work.org" "Work")
;         "** WORK %?\n   %i\n   %a\n   %t")
        ("m" "Memo" entry
         (file+headline nil "MEMO")
         "** %?\n   %i\n   %a\n   %t")))

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
  '(("C" "CustomersCare"
      ((tags "CC")))
    ("U" "MASUI"
      ((tags "MASUI")))
    ("M" "MailCloud"
      ((tags "MailCloud")))
;    ("P" "Project" 
;     ((tags "PROJECT")))
;    ("H" "Office and Home Lists"
;      ((agenda)
;          (tags-todo "WORK")
;          (tags-todo "TECH")
;          (tags-todo "BOOK")
;          (tags-todo "HOME")))
    ("D" "Daily Action List"
      ((agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))))
    ))

(defun gtd ()
    (interactive)
    (find-file (concat org-directory "gtd.org")))

(add-hook 'org-agenda-mode-hook 'hl-line-mode)

(global-set-key (kbd "C-c o g") 'gtd)
(global-set-key (kbd "C-c o o") 'org-capture)
(global-set-key (kbd "C-c o a") 'org-agenda)
(global-set-key (kbd "C-c o l") 'org-store-link)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 `(org-agenda-files ,(list (concat org-directory "gtd.org") (concat org-directory "notes.org")))
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
 '(org-use-fast-todo-selection t))


;; ditaa
(setq org-ditaa-jar-path "~/bin/ditaa.jar")
