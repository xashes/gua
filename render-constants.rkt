#lang racket

(require 2htdp/image)

(provide (all-defined-out))

;; Board
(define BG-WIDTH 1200)
(define BG-HEIGHT 800)
(define BG-COLOR 'white)

;; Gua
(define CENTER-X (/ BG-WIDTH 2))
(define CENTER-Y (/ BG-HEIGHT 2))

;; Yao
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
(define YAO-COLOR 'cyan)
(define YAOCI-SIZE (* YAO-HEIGHT 4/5))
(define YAOCI-COLOR 'black)

;; Text
(define GUANAME-SIZE (* YAO-HEIGHT 8))
(define GUANAME-COLOR (color 0 255 255 160))
(define GUACI-SIZE (* YAO-HEIGHT 1))
(define GUACI-COLOR 'black)

;; Visual constants
(define MTS (empty-scene BG-WIDTH BG-HEIGHT BG-COLOR))
