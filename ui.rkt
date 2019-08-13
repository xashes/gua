#lang racket

(require 2htdp/image
         2htdp/universe
         lang/posn)

(require "gua.rkt")

(define WIDTH 300)
(define HEIGHT 300)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))

(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

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
(define GUA-CENTER-X CENTER-X)
(define GUA-CENTER-Y CENTER-Y)

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
  (-> gua64? image?)
  (let ([yao-imgs (map yao->img g)]
        [x (/ YAO-WIDTH 2)])
    (place-images (reverse yao-imgs)
                  (for/list ([i (in-range 6)])
                    (make-posn x (+ (* i
                                       (+ YAO-HEIGHT GUA-GAP))
                                    (/ YAO-HEIGHT 2))))
                  GUA-BG)))

(define/contract (render/gua g img)
  (-> gua64? image? image?)
  (place-image
   (gua->img g)
   CENTER-X CENTER-Y
   img))

(define/contract (render g)
  (-> gua64? image?)
  (render/gua g MTS)
  )

(define/contract (mouse-on-gua? x y)
  (-> integer? integer? boolean?)
  (let ([left (- GUA-CENTER-X (/ YAO-WIDTH 2))]
        [right (+ GUA-CENTER-X (/ YAO-WIDTH 2))]
        [top (- GUA-CENTER-Y (/ GUA-HEIGHT 2))]
        [bottom (+ GUA-CENTER-Y (/ GUA-HEIGHT 2))]
        )
    (and (< left x right)
         (< top y bottom)))
  )

(define/contract (mouse-handler g x y me)
  (-> gua64? integer? integer? mouse-event? gua64?)
  (if (mouse=? me "button-down")
      (cond
        [(mouse-on-gua? x y) '(1 0 0 0 0 1)]
        [else g]
        )
      g
      )
  )

(define/contract (run ws)
  (-> gua64? gua64?)
  (big-bang ws
            [to-draw render]
            [on-mouse mouse-handler]
            )
  )

(run '(1 1 1 0 0 0))
