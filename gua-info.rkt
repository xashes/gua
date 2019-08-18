#lang racket

(require json
         "gua.rkt")

(provide
 (contract-out
  [get-guainfo (-> gua64? hash?)]
  [get-guaname (-> gua64? string?)]
  [get-guaxu (-> gua64? gua-xu-index?)]
  [get-xugua (-> gua-xu-index? hash?)]
  [get-guaci (-> gua64? string?)]
  ))


(define GUA64-INFO
  (let ([json-data
         (with-input-from-file "gua64.json"
           (lambda () (read-json)))])
    (hash-ref json-data 'gua)))

(define (gua-xu-index? i)
  (and (integer? i)
       (>= i 1)
       (<= i 64)))

(define (string->gua s)
  (map
   (lambda (i) (- i 48))
   (map
    char->integer
    (string->list s))))


(define (get-guainfo gua)
  (list-ref
   (for/list
       ([g (in-list GUA64-INFO)]
        [idx (in-range 1 65)]
        #:when (equal? (string->gua (hash-ref g 'gua-xiang)) gua)
        )
     (hash-set g 'gua-xu idx))
   0))

(define (get-guaname gua)
  (hash-ref (get-guainfo gua) 'gua-name)
  )

(define (get-guaxu gua)
  (hash-ref (get-guainfo gua) 'gua-xu)
  )

(define (get-xugua i)
  (list-ref GUA64-INFO (sub1 i))
  )

(module+ test

  (require rackunit rackunit/text-ui)

  (let ([meng '(0 1 0 0 0 1)]
        [xu '(1 1 1 0 1 0)]
        )
    (check-equal? (get-guaname meng) "蒙")
    (check-equal? (get-guaname xu) "需")
    (check-equal? (get-guaxu meng) 4)
    (check-equal? (get-guaxu xu) 5)
    )

  )

(define (get-guaci gua)
  (hash-ref (get-guainfo gua) 'gua-detail)
  )

(module+ test
  (check-equal? (get-guaci '(1 1 1 1 1 1))
                "元亨利贞。")
  )

(provide (contract-out [get-yaoci (-> gua64? nonnegative-integer? string?)]))
(define (get-yaoci gua yn)
  (list-ref (hash-ref (get-guainfo gua) 'yao-detail) (sub1 yn))
  )
(module+ test
  (check-equal? (get-yaoci '(1 1 1 1 1 1) 1)
                "潜龙勿用。")
  (check-equal? (get-yaoci '(1 1 1 1 1 1) 6)
                "亢龙有悔。")
  )
