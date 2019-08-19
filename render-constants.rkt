#lang racket

(require 2htdp/image)

(provide (all-defined-out))

(define WIDTH 1200)
(define HEIGHT 800)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
(define YAO-COLOR 'cyan)
(define YAOCI-SIZE (* YAO-HEIGHT 4/5))
(define YAOCI-COLOR 'black)
(define GUANAME-SIZE (* YAO-HEIGHT 2))
(define GUANAME-COLOR 'black)
