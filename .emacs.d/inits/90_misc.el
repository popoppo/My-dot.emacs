(require 'uniquify)
(setq-default uniquify-min-dir-content 1)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

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

(use-package markdown-preview-mode
  :straight t)
