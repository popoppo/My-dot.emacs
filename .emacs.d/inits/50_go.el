(setenv "GOPATH" (expand-file-name "~/go"))
(setenv "PATH" (concat (expand-file-name "~/go/bin") ":" (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/go/bin"))

(use-package company-go
  :straight t)

(use-package go-mode
  :straight t
  :mode ("\\.go\\'" . go-mode)
  :commands go-mode
  :hook
  ((go-mode . (lambda ()
                (set (make-local-variable 'company-backends) '(company-go))
                (company-mode)))
   (go-mode . flycheck-mode)
   (before-save . gofmt-before-save)))

;; Use flycheck (name is goflymake though)
;; https://github.com/dougm/goflymake
(use-package go-flycheck
  :straight
  (goflymake :type git
             :host github
             :repo "dougm/goflymake"))
