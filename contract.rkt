#lang racket

(provide (contract-out
          [zero-or-one/c (-> number? boolean?)]
          [3-or-6/c (-> number? boolean?)]
          ))

(define (zero-or-one/c n)
  (or (zero? n) (= n 1)))

(define (3-or-6/c n)
  (or (= n 3) (= n 6)))
