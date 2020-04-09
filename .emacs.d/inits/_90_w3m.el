(load "w3m")
(setq w3m-use-cookies t)
;; favicon のキャッシュを消さない
;(setq w3m-favicon-cache-expire-wait nil)

; タブを移動する
(define-key w3m-mode-map "l" '(lambda () (interactive) (w3m-next-buffer 1)))
(define-key w3m-mode-map "h" '(lambda () (interactive) (w3m-next-buffer -1)))
; タブを閉じる
;(define-key w3m-mode-map "o" 'w3m-delete-buffer)
; リンクに飛ぶ
(define-key w3m-mode-map "n" 'w3m-next-anchor)
(define-key w3m-mode-map "p" 'w3m-previous-anchor)
; リンクを新しいタブで開く
(define-key w3m-mode-map "o" 'w3m-view-this-url-new-session)
; リンクを普通に開く
(define-key w3m-mode-map "O" 'w3m-view-this-url)
; カーソル下にある画像を表示
(define-key w3m-mode-map "i" 'w3m-toggle-inline-image)
; ブックマークを表示
(define-key w3m-mode-map "m" 'w3m-bookmark-view-new-session)