;; .emacs
(defun set-exec-path-from-shell-PATH ()
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)

;; load-path
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install"))
;;(setq exec-path (append exec-path '(expand-file-name "~/bin")))

;; packages
(require 'package)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(add-to-list 'package-pinned-packages '(clj-refactor . "melpa-stable") t)
(package-initialize)

;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get")
(require 'el-get)
(setq el-get-dir "~/.emacs.d/site-lisp")
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(defvar my:packages
  '(ac-cider
    ace-jump-helm-line
    ace-jump-mode
    apel
    async
    auto-complete
    avy
    bind-key
    ccc
    cdb
    cider
    clj-refactor
    clojure-mode
    color-moccur
    company
    company-quickhelp
    dash
    ddskk
    diminish
    dired-hacks-utils
    dired-subtree
    direx
    dumb-jump
    edn
    el-get
    el-mock
;    eldoc-extension
    epl
    expand-region
    f
    flim
    flycheck
    flycheck-clojure
    flymake-cursor
    foreign-regexp
    ghub
    git-commit
    git-gutter
    goto-chg
    helm
    helm-core
    highlight-symbol
    hydra
    inflections
    jaunte
    jedi
    key-chord
    let-alist
    lispxmp
    magit
    magit-popup
    mew
    ; moz
    multiple-cursors
    mykie
    noflet
    paredit
    peg
    pkg-info
    popup
    popwin
    pos-tip
    python-mode
    queue
    quickrun
    s
    seq
    shell-pop
    slamhound
    smooth-scroll
    spinner
    symbol-overlay
    undo-tree
    use-package
    visual-regexp
    w3m
    with-editor
    yasnippet
    ))


(when nil  ;; Enable manually if needed
  (package-refresh-contents)
  (dolist (package my:packages)
    (unless (package-installed-p package)
      (package-install package))))


;; el-get for modules in github
(use-package el-get
  :disabled
  :init
  (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
  :config
  (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
  (el-get 'sync))

;; (el-get-bundle )

;; org  TODO: move to 90_org.el
(setq org-directory "~/Dropbox/org/")

;; INSTALL
(require 'init-loader)
(setq init-loader-show-log-after-init t)
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
 '(ac-stop-words nil)
 '(ac-use-fuzzy t)
 '(bookmark-save-flag 1)
 '(default-tab-width 4 t)
 '(dumb-jump-debug nil)
 '(foreign-regexp/regexp-type (quote perl))
 '(gud-gdb-command-name "gdb --annotate=1")
 '(ipython-complete-function (quote py-complete))
 '(ipython-complete-use-separate-shell-p nil)
 '(jde-ant-enable-find t)
 '(jde-ant-home "/usr/local/dev/ant")
 '(jde-ant-program "/usr/local/dev/ant/bin/ant" t)
 '(jde-ant-working-directory "")
 '(jde-compile-option-classpath nil)
 '(jde-gen-final-arguments nil)
 '(jde-gen-final-methods nil)
 '(jde-jdk-registry (quote (("1.5" . "/usr/local/java/jdk-1.5"))))
 '(large-file-warning-threshold nil)
 '(lsp-ui-sideline-enable nil)
 '(package-selected-packages
   (quote
    (session init-loader uuidgen markdown-mode markdown-preview-mode ace-jump-helm-line helm helm-ag helm-core helm-git-grep helm-ls-git helm-swoop docker dockerfile-mode forge magit docker-tramp company-tabnine company-lsp lsp-mode lsp-ui company-quickhelp company python-mode yasnippet-snippets apel ccc cdb color-moccur ddskk dired-hacks-utils dired-subtree flim foreign-regexp lispxmp quickrun ace-jump-mode jaunte undo-tree expand-region color-theme underwater-theme afternoon-theme visual-regexp symbol-overlay slamhound shell-pop popwin noflet mykie mew key-chord highlight-symbol goto-chg git-gutter flycheck-clojure flycheck el-mock dumb-jump direx diminish dash clj-refactor ac-cider use-package smooth-scroll)))
 '(pcomplete-cycle-completions nil)
 '(pcomplete-cycle-cutoff-length 1)
 '(reb-re-syntax (quote foreign-regexp))
 '(session-use-package t nil (session))
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eshell-prompt ((t (:foreground "White" :weight bold)))))

(add-hook 'after-init-hook  (lambda() (ansi-term "/bin/bash")))
