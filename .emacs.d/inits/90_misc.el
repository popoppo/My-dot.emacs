;(add-to-list 'load-path "~/.emacs.d/site-lisp/howm/")
;(setq howm-menu-lang 'ja)
;(global-set-key "\C-c,," 'howm-menu)
;(mapc
; (lambda (f)
;   (autoload f
;     "howm" "Hitori Otegaru Wiki Modoki" t))
; '(howm-menu howm-list-all howm-list-recent
;             howm-list-grep howm-create
;             howm-keyword-to-kill-ring))


(require 'uniquify)
(setq-default uniquify-min-dir-content 1)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;; keisen
(global-set-key [C-right] 'keisen-right-move )
(global-set-key [C-left] 'keisen-left-move )
(global-set-key [C-up] 'keisen-up-move )
(global-set-key [C-down] 'keisen-down-move )
(autoload 'keisen-up-move "keisen" nil t)
(autoload 'keisen-down-move "keisen" nil t)
(autoload 'keisen-left-move "keisen" nil t)
(autoload 'keisen-right-move "keisen" nil t)


;; markdown-mode
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  ;; (setq markdown-command "markdown2")
  (setq
   ;;markdown-command "commonmarker --extension=tagfilter,autolink,table,strikethrough"
   ;;markdown-command "github-markup"
   markdown-command "pandoc"
   ;; markdown-command-needs-filename t
   ;; markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
   ;;                      "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
   ;; markdown-xhtml-header-content "<script src=\"https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js\"></script><script>hljs.initHighlightingOnLoad();</script>"
   ;; markdown-xhtml-body-preamble "<div class=\"markdown-body\">"
   ;; markdown-xhtml-body-epilogue "</div>")
  ;;(setq markdown-preview-stylesheets (list "github.css"))
  ))
