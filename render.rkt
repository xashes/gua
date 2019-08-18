#lang racket

(require 2htdp/image
         2htdp/universe
         "gua.rkt")

(provide (contract-out [struct guapic
                         ([xiang gua?]
                          [posn (vectorof real?)]
                          [width real?])]
                       [struct (yaopic guapic)
                         ([xiang yao?]
                          [posn (vectorof real?)]
                          [width real?]
                          [color (or/c symbol? color?)]
                          [gap-color (or/c symbol? color?)])]))

(provide render/guapic
         get-edges/guapic
         guapic->yaopic-list)

;; structs for render
(struct guapic (xiang posn width) #:transparent)
(struct yaopic guapic (color gap-color) #:transparent)
(module+ test
  (require rackunit rackunit/text-ui)

  (define guapic0 (guapic '(1 1 0 0 0 1)
                    #(200 300)
                    200))
  (define yaopic0 (yaopic 0
                    #(100 80)
                    200
                    'cyan
                    'white))
  (define yaopic1 (struct-copy yaopic yaopic0 [xiang #:parent guapic 1]))
  )

;; private
(define/contract (get-yaopic-height w)
  (-> real? real?)
  (* w 0.15)
  )
(module+ test
  (check-= (get-yaopic-height 200) 30 0.001)
  )

;; private
(define/contract (get-yaopic-gap w)
  (-> real? real?)
  (* (get-yaopic-height w) 1/3)
  )
(module+ test
  (check-= (get-yaopic-gap 200) 10 0.001)
  )

;; private
(define/contract (get-guapic-height w)
  (-> real? real?)
  (+ (* (get-yaopic-height w) 6)
     (* (get-yaopic-gap w) 5)))
(module+ test
  (check-= (get-guapic-height 200) 230 0.001)
  )

(define/contract (get-height g)
  (-> guapic? real?)
  (let ([w (guapic-width g)])
    (if (yaopic? g)
        (get-yaopic-height w)
        (get-guapic-height w))))
(module+ test
  (check-= (get-height guapic0) 230 0.001)
  (check-= (get-height yaopic1) 30 0.001)
  )

(define/contract (get-edges/guapic g)
  (-> guapic? (vectorof real?))
  (let-values ([(x y) (vector->values (guapic-posn g))])
    (let* ([width (guapic-width g)]
           [height (get-height g)]
           [left (- x (/ width 2))]
           [right (+ x (/ width 2))]
           [top (- y (/ height 2))]
           [bottom (+ y (/ height 2))]
           )
      (vector left right top bottom)))
  )
(module+ test
  (check-equal? (get-edges/guapic guapic0)
                #(100 300 185.0 415.0))
  )

(define/contract (get-bottom-y g)
  (-> guapic? real?)
  (let* ([p (guapic-posn g)]
         [y (vector-ref p 1)])
    (+ y
       (/ (get-height g) 2))))
(module+ test
  (check-= (get-bottom-y guapic0) 415 0.001)
  )

(define/contract (guapic->yaopic-ys g)
  (-> guapic? (listof real?))
  (let* ([xiang (guapic-xiang g)]
         [w (guapic-width g)]
         [yh (get-yaopic-height w)]
         [by (get-bottom-y g)]
         )
    (for/list ([i (in-range (length xiang))])
      (- by
         (+ (* i
               (* yh 4/3))
            (/ yh 2))))))
(module+ test
  (check-equal? (guapic->yaopic-ys guapic0)
                (reverse '(200.0 240.0 280.0 320.0 360.0 400.0))))

(define/contract (guapic->yaopic-list g [color 'cyan] [gap-color 'white])
  (->* (guapic?) ((or/c symbol? color?) (or/c symbol? color?)) (listof yaopic?))
  (for/list ([xiang (in-list (guapic-xiang g))]
             [y (in-list (guapic->yaopic-ys g))])
    (let ([x (vector-ref (guapic-posn g) 0)]
          [w (guapic-width g)])
      (yaopic xiang (vector x y) w color gap-color))))
(module+ test
  (check-equal? (guapic->yaopic-list guapic0 'cyan 'white)
                (for/list ([y (in-list (reverse '(200.0 240.0 280.0 320.0 360.0 400.0)))]
                           [xiang (in-list (guapic-xiang guapic0))])
                  (yaopic xiang (vector 200 y) 200 'cyan 'white)))
  )
(define/contract (yaopic->image yr)
  (-> yaopic? image?)
  (let-values ([(s xiang _ w c gc)
                (vector->values (struct->vector yr))])
    (let* ([h (get-yaopic-height w)]
           [yang (rectangle w h 'solid c)])
      (if (zero? xiang)
          (overlay (rectangle (* w 1/5) (+ h 1) 'solid gc)
                   yang)
          yang
          ))))
(module+ test
  (check-equal? (yaopic->image yaopic0)
                (overlay (rectangle 40 31 'solid 'white)
                         (rectangle 200 (get-yaopic-height 200)
                                    'solid
                                    'cyan)))
  (check-equal? (yaopic->image yaopic1)
                (rectangle 200 30 'solid 'cyan))
  )

(define/contract (render/yaopic yr bg)
  (-> yaopic? image? image?)
  (let-values ([(x y) (vector->values (guapic-posn yr))])
    (place-image (yaopic->image yr)
                 x y
                 bg)))
(module+ test
  (define WIDTH 400)
  (define HEIGHT 400)
  (define BG-COLOR 'white)
  (define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

  (check-equal? (render/yaopic yaopic0 MTS)
                (place-image (yaopic->image yaopic0)
                             100 80
                             MTS))
  )

(define/contract (render/guapic g bg [c 'cyan] [gap-c 'white])
  (-> guapic? image? (or/c symbol? color?) (or/c symbol? color?) image?)
  (for/fold ([bg bg])
            ([yao (in-list (guapic->yaopic-list g c gap-c))])
    (render/yaopic yao bg)))
(module+ test
  (check-equal? (render/guapic guapic0 MTS 'cyan 'white)
                (for/fold ([bg MTS])
                          ([xiang (guapic-xiang guapic0)]
                           [y (in-list (guapic->yaopic-ys guapic0))])
                  (render/yaopic (yaopic xiang (vector 200 y) 200 'cyan 'white) bg)))
  )
