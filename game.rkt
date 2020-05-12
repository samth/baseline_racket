#lang racket
(require 2htdp/image)
(require 2htdp/universe)
;(require "controles.rkt")

(struct State
  (angle)
  #:transparent)

(struct pos-ang
  (ro
   a)   ; alpha
  #:transparent)

(define FPS 60)
(define GAME-WIDTH 400)
(define GAME-HEIGHT GAME-WIDTH)
(define ROT-SPEED (/ pi 2)) ; radians per second

(define INITIAL-STATE
  (State 0))

(define (update-state s)
  (State (update-angle (State-angle s))))

(define (update-angle a)
  (define new-angle (+ a (/ ROT-SPEED FPS)))
  (if (> new-angle (* 2 pi))
      (- new-angle (* 2 pi))
      new-angle))

(define g-cactus (bitmap "cactus1.png"))

(define CACTI-COUNT 30)
(define CACTI-LIST (for/list ([i (in-range CACTI-COUNT)])
                             (pos-ang (* 200 (random))
                                      (* i (/ (* 2 pi) CACTI-COUNT)))))

(define (draw-object graphic p bg) ; p: angular position, bg: background image
  (place-image/align
    graphic
    (+ (* (pos-ang-ro p) (cos (pos-ang-a p))) (/ GAME-WIDTH 2))
    (+ (* (pos-ang-ro p) (sin (pos-ang-a p))) (/ GAME-HEIGHT 2))
    "center" "bottom"
    bg))

(define (draw-cacti bg angle)
  (define (draw-one-cactus p bg)
    (draw-object g-cactus (pos-ang (pos-ang-ro p) (+ (pos-ang-a p) angle)) bg))
  (foldl draw-one-cactus bg CACTI-LIST))

(define (draw-state s)
  (define blank-scene (empty-scene GAME-WIDTH GAME-HEIGHT))
  (draw-cacti blank-scene (State-angle s)))

(provide update-state
         draw-state
         INITIAL-STATE
         State
         FPS)
