#lang racket

(require gua/gua
         gua/contract)

(provide (contract-out
          [jinqiangua (-> (listof zero-or-one/c))]))

(define (jinqiangua)
  '()
  )

(define (generate-yao)
  (let ([zero-count (count zero? (random-gua 3))])
    (case zero-count
      [(0) 9]
      [(1) 0]
      [(2) 1]
      [(3) 6]
      )))
