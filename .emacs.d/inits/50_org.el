;; Org mode
(require 'org)

;;(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-directory "/Users/koji.takahashi/Dropbox/org/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(setq my:org-gtd-file (concat org-directory "gtd.org"))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline my:org-gtd-file "TODO")
         "** %? %t")
        ("m" "Memo" entry (file+headline org-default-notes-file "MEMO")
         "** %?")))

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
  '(
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
                      ))))))

(defun my:gtd ()
    (interactive)
    (find-file (concat org-directory "gtd.org")))

(add-hook 'org-agenda-mode-hook 'hl-line-mode)

(global-set-key (kbd "C-c o g") 'my:gtd)
(global-set-key (kbd "C-c o o") 'org-capture)
(global-set-key (kbd "C-c o a") 'org-agenda)
(global-set-key (kbd "C-c o l") 'org-store-link)

(setq org-agenda-files (list (concat org-directory "gtd.org") (concat org-directory "notes.org")))

;;(custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;; `(org-agenda-files ,(list (concat org-directory "gtd.org") (concat org-directory "notes.org")))
;; '(org-agenda-include-diary nil)
;; '(org-agenda-ndays 7)
;; '(org-agenda-repeating-timestamp-show-all t)
;; '(org-agenda-restore-windows-after-quit t)
;; '(org-agenda-show-all-dates t)
;; '(org-agenda-skip-deadline-if-done t)
;; '(org-agenda-skip-scheduled-if-done t)
;; '(org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
;; '(org-agenda-start-on-weekday nil)
;; '(org-agenda-window-setup (quote other-window))
;; '(org-deadline-warning-days 7)
;; '(org-fast-tag-selection-single-key nil)
;; '(org-insert-mode-line-in-empty-file t)
;; '(org-log-done (quote (done)))
;; '(org-refile-targets (quote (("gtd.org" :maxlevel . 1) ("archive.org" :maxlevel . 1))))
;; '(org-reverse-note-order nil)
;; '(org-tags-match-list-sublevels t)
;;;; '(org-time-stamp-rounding-minutes (quote (0 5)))
;; '(org-timeline-show-empty-dates t)
;; '(org-use-fast-todo-selection t))


;; ditaa
;; (setq org-ditaa-jar-path "~/bin/ditaa.jar")
