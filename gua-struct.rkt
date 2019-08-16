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

(define/contract (get-yao-height w)
  (-> real? real?)
  (* w 0.15)
  )
(module+ test
  (check-= (get-yao-height 200) 30 0.001)
  )

(define/contract (get-yao-gap w)
  (-> real? real?)
  (* (get-yao-height w) 1/3)
  )
(module+ test
  (check-= (get-yao-gap 200) 10 0.001)
  )

(define/contract (get-gua-height w)
  (-> real? real?)
  (+ (* (get-yao-height w) 6)
     (* (get-yao-gap w) 5)))
(module+ test
  (check-= (get-gua-height 200) 230 0.001)
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
