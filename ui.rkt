#lang racket

(require 2htdp/image
         2htdp/universe
         lang/posn)

(require "gua.rkt")

(define WIDTH 300)
(define HEIGHT 300)
(define MTS (empty-scene WIDTH HEIGHT))

(define BG-COLOR 'white)
(define YAO-COLOR 'cyan)
(define YAO-WIDTH 100)
(define YAO-HEIGHT 15)
(define YIN-GAP (* YAO-WIDTH 1/5))
(define YANG (rectangle YAO-WIDTH YAO-HEIGHT 'solid YAO-COLOR))
(define YIN (overlay (rectangle YIN-GAP (+ YAO-HEIGHT 1) 'solid BG-COLOR)
                     YANG))
(define GUA-GAP (* YAO-HEIGHT 1/3))
(define GUA-HEIGHT (+ (* YAO-HEIGHT 6)
                      (* GUA-GAP 5)))
(define GUA-BG (rectangle YAO-WIDTH GUA-HEIGHT 'outline BG-COLOR))

(define/contract (yao->img y)
  (-> yao? image?)
  (if (zero? y)
      YIN
      YANG))
(module+ test
  (require rackunit rackunit/text-ui)

  (check-equal? (yao->img 0) YIN)
  (check-equal? (yao->img 1) YANG)
  )

(define/contract (gua->img g)
  (-> gua? image?)
  (let ([yao-imgs (map yao->img g)]
        [x (/ YAO-WIDTH 2)])
    (place-images (reverse yao-imgs)
                  (for/list ([i (in-range 6)])
                    (make-posn x (+ (* i
                                  (+ YAO-HEIGHT GUA-GAP))
                               (/ YAO-HEIGHT 2))))
                  GUA-BG)))
(place-image
 (gua->img '(0 0 0 1 0 1))
 150 150
 MTS)

(define/contract (point-on-img? x y img)
  (-> real? real? image? boolean?)
  #f
  )
