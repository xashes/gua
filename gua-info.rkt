#lang racket

(require json
         "gua.rkt")

(provide
 (contract-out
  [gua-info (-> gua64? hash?)]
  [gua-name (-> gua64? string?)]
  [gua-xu (-> gua64? gua-xu-index?)]
  [xu-gua (-> gua-xu-index? hash?)]
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


(define (gua-info gua)
  (list-ref
   (for/list
       ([g (in-list GUA64-INFO)]
        [idx (in-range 1 65)]
        #:when (equal? (string->gua (hash-ref g 'gua-xiang)) gua)
        )
     (hash-set g 'gua-xu idx))
   0))

(define (gua-name gua)
  (hash-ref (gua-info gua) 'gua-name)
  )

(define (gua-xu gua)
  (hash-ref (gua-info gua) 'gua-xu)
  )

(define (xu-gua i)
  (list-ref GUA64-INFO (sub1 i))
  )

(module+ test

  (require rackunit rackunit/text-ui)

  (let ([meng '(0 1 0 0 0 1)]
        [xu '(1 1 1 0 1 0)]
        )
    (check-equal? (gua-name meng) "蒙")
    (check-equal? (gua-name xu) "需")
    (check-equal? (gua-xu meng) 4)
    (check-equal? (gua-xu xu) 5)
    (xu-gua 63)
    )

  )
