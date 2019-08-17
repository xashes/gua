#lang racket

(require 2htdp/image
         2htdp/universe
         "gua.rkt")

(provide (contract-out [struct guar
                         ([xiang gua?]
                          [posn (vectorof real?)]
                          [width real?])]
                       [struct (yaor guar)
                         ([xiang yao?]
                          [posn (vectorof real?)]
                          [width real?]
                          [color (or/c symbol? color?)]
                          [gap-color (or/c symbol? color?)])]))

;; (provide mouse-on-guar?
;;          mouse-on-yaor-n?
;;          render/gua)

;; structs for render
(struct guar (xiang posn width) #:transparent)
(struct yaor guar (color gap-color) #:transparent)
(module+ test
  (require rackunit rackunit/text-ui)

  (define guar0 (guar '(1 1 0 0 0 1)
                    #(200 300)
                    200))
  (define yaor0 (yaor 0
                    #(100 80)
                    200
                    'cyan
                    'white))
  (define yaor1 (struct-copy yaor yaor0 [xiang #:parent guar 1]))
  )

;; private
(define/contract (get-yaor-height w)
  (-> real? real?)
  (* w 0.15)
  )
(module+ test
  (check-= (get-yaor-height 200) 30 0.001)
  )

;; private
(define/contract (get-yaor-gap w)
  (-> real? real?)
  (* (get-yaor-height w) 1/3)
  )
(module+ test
  (check-= (get-yaor-gap 200) 10 0.001)
  )

;; private
(define/contract (get-guar-height w)
  (-> real? real?)
  (+ (* (get-yaor-height w) 6)
     (* (get-yaor-gap w) 5)))
(module+ test
  (check-= (get-guar-height 200) 230 0.001)
  )

(define/contract (get-height g)
  (-> guar? real?)
  (let ([w (guar-width g)])
    (if (yaor? g)
        (get-yaor-height w)
        (get-guar-height w))))
(module+ test
  (check-= (get-height guar0) 230 0.001)
  (check-= (get-height yaor1) 30 0.001)
  )

(define/contract (get-edges/guar g)
  (-> guar? (vectorof real?))
  (let-values ([(x y) (vector->values (guar-posn g))])
    (let* ([width (guar-width g)]
           [height (get-height g)]
           [left (- x (/ width 2))]
           [right (+ x (/ width 2))]
           [top (- y (/ height 2))]
           [bottom (+ y (/ height 2))]
           )
      (vector left right top bottom)))
  )
(module+ test
  (check-equal? (get-edges/guar guar0)
                #(100 300 185.0 415.0))
  )

(define/contract (mouse-on-guar? mx my g)
  (-> integer? integer? guar? boolean?)
  (let-values ([(left right top bottom)
                (vector->values (get-edges/guar g))])
    (and (<= left mx right)
         (<= top my bottom))))
(module+ test
  (check-true (mouse-on-guar? 100 186 guar0))
  (check-true (mouse-on-guar? 300 415 guar0))
  (check-false (mouse-on-guar? 300 416 guar0))
  (check-false (mouse-on-guar? 301 186 guar0))
  (check-false (mouse-on-guar? 99 186 guar0))
  (check-false (mouse-on-guar? 100 184 guar0))

  (check-false (mouse-on-guar? 100 48 yaor0))
  (check-true (mouse-on-guar? 100 80 yaor0))
  )

(define/contract (get-bottom-y g)
  (-> guar? real?)
  (let* ([p (guar-posn g)]
         [y (vector-ref p 1)])
    (+ y
       (/ (get-height g) 2))))
(module+ test
  (check-= (get-bottom-y guar0) 415 0.001)
  )

(define/contract (guar->yaor-ys g)
  (-> guar? (listof real?))
  (let* ([xiang (guar-xiang g)]
         [w (guar-width g)]
         [yh (get-yaor-height w)]
         [by (get-bottom-y g)]
         )
    (for/list ([i (in-range (length xiang))])
      (- by
         (+ (* i
               (* yh 4/3))
            (/ yh 2))))))
(module+ test
  (check-equal? (guar->yaor-ys guar0)
                (reverse '(200.0 240.0 280.0 320.0 360.0 400.0))))

(define/contract (guar->yaor-list g color gap-color)
  (-> guar? (or/c symbol? color?) (or/c symbol? color?) (listof yaor?))
  (for/list ([xiang (in-list (guar-xiang g))]
             [y (in-list (guar->yaor-ys g))])
    (let ([x (vector-ref (guar-posn g) 0)]
          [w (guar-width g)])
      (yaor xiang (vector x y) w color gap-color))))
(module+ test
  (check-equal? (guar->yaor-list guar0 'cyan 'white)
                (for/list ([y (in-list (reverse '(200.0 240.0 280.0 320.0 360.0 400.0)))]
                           [xiang (in-list (guar-xiang guar0))])
                  (yaor xiang (vector 200 y) 200 'cyan 'white)))
  )
(define/contract (yaor->image yr)
  (-> yaor? image?)
  (let-values ([(s xiang _ w c gc)
                (vector->values (struct->vector yr))])
    (let* ([h (get-yaor-height w)]
           [yang (rectangle w h 'solid c)])
      (if (zero? xiang)
          (overlay (rectangle (* w 1/5) (+ h 1) 'solid gc)
                   yang)
          yang
          ))))
(module+ test
  (check-equal? (yaor->image yaor0)
                (overlay (rectangle 40 31 'solid 'white)
                         (rectangle 200 (get-yaor-height 200)
                                    'solid
                                    'cyan)))
  (check-equal? (yaor->image yaor1)
                (rectangle 200 30 'solid 'cyan))
  )

(define/contract (render/yaor yr bg)
  (-> yaor? image? image?)
  (let-values ([(x y) (vector->values (guar-posn yr))])
    (place-image (yaor->image yr)
                 x y
                 bg)))
(module+ test
  (define WIDTH 400)
  (define HEIGHT 400)
  (define BG-COLOR 'white)
  (define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

  (check-equal? (render/yaor yaor0 MTS)
                (place-image (yaor->image yaor0)
                             100 80
                             MTS))
  )

(define/contract (render/guar g c gap-c bg)
  (-> guar? (or/c symbol? color?) (or/c symbol? color?) image? image?)
  (for/fold ([bg bg])
            ([yao (in-list (guar->yaor-list g c gap-c))])
    (render/yaor yao bg)))
(module+ test
  (check-equal? (render/guar guar0 'cyan 'white MTS)
                (for/fold ([bg MTS])
                          ([xiang (guar-xiang guar0)]
                           [y (in-list (guar->yaor-ys guar0))])
                  (render/yaor (yaor xiang (vector 200 y) 200 'cyan 'white) bg)))
  )
