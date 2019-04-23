#lang racket

(provide (contract-out
          [yao/c (-> number? boolean?)]
          [3-or-6/c (-> number? boolean?)]
          ))

(define (yao/c n)
  (or/c (zero? n) (= n 1)))

(define (3-or-6/c n)
  (or (= n 3) (= n 6)))
