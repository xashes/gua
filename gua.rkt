#lang racket


(define gua
  (hash
   '(1 1 1) (hash 'name '乾)
   '(0 1 0) (hash 'name '坎)
   '(0 0 1) (hash 'name '艮)
   '(1 0 0) (hash 'name '震)
   '(0 1 1) (hash 'name '巽)
   '(1 0 1) (hash 'name '离)
   '(0 0 0) (hash 'name '坤)
   '(1 1 0) (hash 'name '兑)
   ))

(define (gua-name code)
  (hash-ref (hash-ref gua code) 'name))

(provide gua-name)

(define (generate-code)
  (list (random 2) (random 2) (random 2)))

(provide generate-code)
