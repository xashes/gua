#lang racket

(require 2htdp/image)

(provide (all-defined-out))

(define BG-WIDTH 1200)
(define BG-HEIGHT 800)
(define CENTER-X (/ BG-WIDTH 2))
(define CENTER-Y (/ BG-HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene BG-WIDTH BG-HEIGHT BG-COLOR))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
(define YAO-COLOR 'cyan)
(define YAOCI-SIZE (* YAO-HEIGHT 4/5))
(define YAOCI-COLOR 'black)
(define GUANAME-SIZE (* YAO-HEIGHT 8))
(define GUANAME-COLOR 'black)
