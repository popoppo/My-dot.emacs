;; keisen.el -- provide facility for drawing ruled-line
;;
;; Copyright (C) 1990-2004 $BA}0f=SG7(B  masui@pitecan.com
;;
;; This is a Public Domain Software.
;; Everyone is granted permission to copy, modify and redistribute
;; this program freely.
 
;; .emacs$B$K0J2<$N$h$&$J5-=R$rF~$l$k$HLp0u%-!<$G7S@~$,0z$1$k(B
;;
;; $BJ8;zC<Kv$NLp0u%-!<$G7S@~$r0z$/>l9g(B
;; (global-set-key "\eOA" 'keisen-up-move)
;; (global-set-key "\eOB" 'keisen-down-move)
;; (global-set-key "\eOD" 'keisen-left-move)
;; (global-set-key "\eOC" 'keisen-right-move)
;;
;; $BJ8;zC<Kv$N(BMeta-P$B$J$I$G7S@~$r0z$/>l9g(B
;; (global-set-key "\M-p" 'keisen-up-move)
;; (global-set-key "\M-n" 'keisen-down-move)
;; (global-set-key "\M-b" 'keisen-left-move)
;; (global-set-key "\M-f" 'keisen-right-move)
;;
;; Control+$BLp0u%-!<$G7S@~$r0z$/>l9g(B
;; (global-set-key [C-right] 'keisen-right-move)
;; (global-set-key [C-left]  'keisen-left-move)
;; (global-set-key [C-up]    'keisen-up-move)
;; (global-set-key [C-down]  'keisen-down-move)
;;
;; (autoload 'keisen-up-move "keisen" nil t)
;; (autoload 'keisen-down-move "keisen" nil t)
;; (autoload 'keisen-left-move "keisen" nil t)
;; (autoload 'keisen-right-move "keisen" nil t)
 
;;; 92.7.6   modified for Mule Ver.0.9.5 by T.Shingu <shingu@cpr.canon.co.jp>
;;; 92.7.13  modified for Mule Ver.0.9.5 by K.Handa <handa@etl.go.jp>
;;; 93.8.5   modified for dmacro.el by T.Masui <masui@shpcsl.sharp.co.jp>
;;; 93.8.5   modified for Mule Ver.1.1 by K.Handa <handa@etl.go.jp>
;;;	To be used also with Nemacs.
;;; 2004.5.6 modified for Emacs21 by T.Masui <masui@pitecan.com>

(provide 'keisen)
(require 'picture)
 
(defconst keisen-right 1)
(defconst keisen-up 2)
(defconst keisen-left 4)
(defconst keisen-down 8)
 
(defconst keisen-table "\
$B!v!v!v(&!v(!(%(*!v(#("('($((()(+(B\
$B!v!v!v!v!v!v!v!v!v!v(<!v!v!v!v!v(B\
$B!v!v!v!v!v(?!v!v!v!v!v!v!v!v!v!v(B\
$B(1!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B!v!v!v!v!v!v!v!v!v!v(>!v!v!v!v!v(B\
$B(,!v(:!v!v!v!v!v(8!v(;!v!v!v!v!v(B\
$B(0!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(5!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B!v!v!v!v!v(=!v!v!v!v!v!v!v!v!v!v(B\
$B(.!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(-(7!v!v(9(@!v!v!v!v!v!v!v!v!v!v(B\
$B(2!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(/!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(3!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(4!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B\
$B(6!v!v!v!v!v!v!v!v!v!v!v!v!v!v!v(B"
  "$B7S@~%-%c%i%/%?$N3FJ}8~$N;^$NM-L5$r(B8$B%S%C%H$GI=8=$9$k!#(B
$B%$%s%G%C%/%9$N>e0L(B4$B%S%C%H$OB@$$@~$NM-L5$r<($7!"2<0L(B4$B%S%C%H$,(B
$B:Y$$@~$NM-L5$r<($9!#(B")
 
(defvar keisen-width 1
  "$B7S@~$NB@$5!#(B1$B$N$H$-:Y$/!"(B2$B0J>e$N$H$-B@$$!#(B")
 
(defun keisen-toggle-width ()
  "$B7S@~$NB@$5$r@Z$j49$($k(B"
  (interactive)
  (cond
   ((> keisen-width 1) (message "$B:Y$$7S@~$r;HMQ$7$^$9(B") (setq keisen-width 1))
   (t (message  "$BB@$$7S@~$r;HMQ$7$^$9(B") (setq keisen-width 2))
   ))
 
(defun keisen-opposite-direction (dir)
  (cond
   ((= dir keisen-right) keisen-left)
   ((= dir keisen-left) keisen-right)
   ((= dir keisen-up) keisen-down)
   ((= dir keisen-down) keisen-up)
   (t 0)
   ))
 
(defun keisen-direction (command)
  (cond
   ((eq command 'keisen-right-move) keisen-right)
   ((eq command 'keisen-left-move) keisen-left)
   ((eq command 'keisen-up-move) keisen-up)
   ((eq command 'keisen-down-move) keisen-down)
   ((eq command t) keisen-last-direction) ; 93.8.5 by T.Masui
   (t 0)))
 
(defun keisen-new-string ()		; 92.7.13 by K.Handa -- Big change
  (let (pos factor str old-direction new-direction)
    (setq old-direction (keisen-direction last-command))
    (setq new-direction (keisen-direction this-command))
    (setq keisen-last-direction new-direction) ; 93.8.5 by T.Masui
    (setq factor (if (> keisen-width 1) 16 1))
    (setq str (if (eobp) " "
		(buffer-substring (point) (+ (point) 1))))
    (setq pos (string-match str keisen-table))
    (if (null pos)
	(progn
	  (setq pos 0)
	  (if (= old-direction (keisen-opposite-direction new-direction))
	      (setq old-direction new-direction))
	  (if (= old-direction 0) (setq old-direction new-direction))
      ))
    (setq pos (logior pos
		      (* (keisen-opposite-direction old-direction) factor)
		      (* new-direction factor)))
    (substring keisen-table pos (+ pos 1))
    ))

(defun keisen-move (v h)
  (setq picture-vertical-step v)
  (setq picture-horizontal-step h)
  (setq picture-desired-column (current-column))
  (picture-insert (string-to-char (keisen-new-string)) 1)
  )

(defun keisen-right-move ()
  "$B7S@~$r0z$-$J$,$i1&J}8~$K0\F0$9$k(B" 
  (interactive)
  (keisen-move 0 1))
			  
(defun keisen-left-move ()
  "$B7S@~$r0z$-$J$,$i:8J}8~$K0\F0$9$k(B"
  (interactive)
  (keisen-move 0 -1))

(defun keisen-up-move ()
  "$B7S@~$r0z$-$J$,$i>eJ}8~$K0\F0$9$k(B"
  (interactive)
  (keisen-move -1 0))

(defun keisen-down-move ()
  "$B7S@~$r0z$-$J$,$i2<J}8~$K0\F0$9$k(B"
  (interactive)
  (keisen-move 1 0))
