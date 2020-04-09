(use-package eww
  :config
  (bind-keys :map eww-mode-map
             ("h" . backward-char)
             ("j" . next-line)
             ("k" . previous-line)
             ("l" . forward-char)
             ("J" . View-scroll-line-forward)
             ("K" . View-scroll-line-backward)
             ("s-[" . eww-back-url)
             ("s-]" . eww-forward-url)
             ("s-{" . previous-buffer)
             ("s-}" . next-buffer)))
