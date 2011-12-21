;; flymake
(require 'flymake)
(set-variable 'flymake-log-level 9)
(setq flymake-start-syntax-check-on-newline nil)
(setq flymake-no-changes-timeout 10)

(require 'flymake-cursor)

;; Inhibit GUI warning
;(setq flymake-gui-warnings-enabled nil)

;; enable flymake on all files
;(add-hook 'find-file-hook 'flymake-find-file-hook)

;; move command
(global-set-key "\C-cp" 'flymake-goto-prev-error)
(global-set-key "\C-cn" 'flymake-goto-next-error)

;; display error/warning line
;(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)


;(defun my-java-flymake-init ()
;  (list "javac" (list (flymake-init-create-temp-buffer-copy
;                       'flymake-create-temp-with-folder-structure))))

;; specify that flymake use ant instead of make 
(setcdr (assoc "\\.java\\'" flymake-allowed-file-name-masks)
        '(flymake-simple-ant-java-init flymake-simple-java-cleanup))

;; redefine to remove "check-syntax" target
(defun flymake-get-ant-cmdline (source base-dir)
  (list "ant"
        (list "-buildfile"
              (concat (file-truename base-dir) "/" "build.xml"))))

(defun flymake-display-err-minibuf () 
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count              (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((text       (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))
