#lang racket
(require 2htdp/universe)
(require "game.rkt")

(define (start-game fps)
  (big-bang INITIAL-STATE
    (on-tick update-state (/ 1 fps))
    (to-draw draw-state)))

(start-game FPS)