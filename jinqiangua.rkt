#lang racket

(require gua/gua
         gua/contract)

(provide (contract-out
          [jinqiangua (-> (listof zero-or-one/c))]))

(define (jinqiangua)
  (for/list ([i (in-range 6)])
    (generate-yao))
  )

(define (generate-yao)
  (let ([zero-count (count zero? (random-gua 3))])
    (case zero-count
      [(0) 9]
      [(1) 8]
      [(2) 7]
      [(3) 6]
      )))

(jinqiangua)

(struct gua (name code pos) #:transparent)
(define dt
  (list (gua "乾" '(1 1 1) "south")
        (gua "坤" '(0 0 0) "north"))
  )
