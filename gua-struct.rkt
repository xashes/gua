#lang racket

(require 2htdp/image
         2htdp/universe
         "gua-xiang.rkt")

(provide (contract-out [struct gua
                         ([xiang gua-xiang?]
                          [posn (vectorof real?)]
                          [width real?])]
                       [struct (yao gua)
                         ([xiang yao-xiang?]
                          [posn (vectorof real?)]
                          [width real?]
                          [color color?]
                          [gap-color color?])]))
(struct gua (xiang posn width) #:transparent)
(struct yao gua (color gap-color) #:transparent)
(module+ test
  (require rackunit rackunit/text-ui)

  (define gua0 (gua '(1 1 0 0 0 1)
                    #(200 300)
                    200))
  (define yao0 (yao 0
                    #(100 80)
                    200
                    'cyan
                    'white))
  (define yao1 (struct-copy yao yao0 [xiang #:parent gua 1]))
  )

;; private
(define/contract (get-yao-height w)
  (-> real? real?)
  (* w 0.15)
  )
(module+ test
  (check-= (get-yao-height 200) 30 0.001)
  )

;; private
(define/contract (get-yao-gap w)
  (-> real? real?)
  (* (get-yao-height w) 1/3)
  )
(module+ test
  (check-= (get-yao-gap 200) 10 0.001)
  )

;; private
(define/contract (get-gua-height w)
  (-> real? real?)
  (+ (* (get-yao-height w) 6)
     (* (get-yao-gap w) 5)))
(module+ test
  (check-= (get-gua-height 200) 230 0.001)
  )

(define/contract (get-height g)
  (-> gua? real?)
  (let ([w (gua-width g)])
    (if (yao? g)
        (get-yao-height w)
        (get-gua-height w))))
(module+ test
  (check-= (get-height gua0) 230 0.001)
  (check-= (get-height yao1) 30 0.001)
  )

(define/contract (yao->image y)
  (-> yao? image?)
  (let-values ([(s xiang _ w c gc)
                (vector->values (struct->vector y))])
    (let* ([h (get-yao-height w)]
           [yang (rectangle w h 'solid c)])
      (if (zero? xiang)
          (overlay (rectangle (* w 1/5) (+ h 1) 'solid gc)
                   yang)
          yang
          ))))
(module+ test
  (check-equal? (yao->image yao0)
                (overlay (rectangle 40 31 'solid 'white)
                         (rectangle 200 (get-yao-height 200)
                                    'solid
                                    'cyan)))
  (check-equal? (yao->image yao1)
                (rectangle 200 30 'solid 'cyan))
  )

(define/contract (render/yao yo bg)
  (-> yao? image? image?)
  (let-values ([(x y) (vector->values (gua-posn yo))])
    (place-image (yao->image yo)
                 x y
                 bg)))
(module+ test
  (define WIDTH 300)
  (define HEIGHT 300)
  (define BG-COLOR 'white)
  (define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

  (check-equal? (render/yao yao0 MTS)
                (place-image (yao->image yao0)
                             100 80
                             MTS))
  )

(define/contract (get-edges g)
  (-> gua? (vectorof real?))
  (let-values ([(x y) (vector->values (gua-posn g))])
    (let* ([width (gua-width g)]
           [height (get-height g)]
           [left (- x (/ width 2))]
           [right (+ x (/ width 2))]
           [top (- y (/ height 2))]
           [bottom (+ y (/ height 2))]
           )
      (vector left right top bottom)))
  )
(module+ test
  (check-equal? (get-edges gua0)
                #(100 300 185.0 415.0))
  )

(define/contract (mouse-on? mx my g)
  (-> integer? integer? gua? boolean?)
  (let-values ([(left right top bottom)
                (vector->values (get-edges g))])
    (and (<= left mx right)
         (<= top my bottom))))
(module+ test
  (check-true (mouse-on? 100 186 gua0))
  (check-true (mouse-on? 300 415 gua0))
  (check-false (mouse-on? 300 416 gua0))
  (check-false (mouse-on? 301 186 gua0))
  (check-false (mouse-on? 99 186 gua0))
  (check-false (mouse-on? 100 184 gua0))

  (check-false (mouse-on? 100 48 yao0))
  (check-true (mouse-on? 100 80 yao0))
  )
