#lang racket

(require json
         "gua.rkt")

(provide
 (contract-out
  [gua-info (-> gua64? hash?)]
  [gua-name (-> gua64? string?)]
  ))


(define gua64-info
  (with-input-from-file "gua64.json"
    (lambda () (read-json))))

(define (string->gua s)
  (map
   (lambda (i) (- i 48))
   (map
    char->integer
    (string->list s))))

(define (gua-info gua)
  (list-ref
   (for/list
       ([g (in-list (hash-ref gua64-info 'gua))]
        #:when (equal? (string->gua (hash-ref g 'gua-xiang)) gua)
        )
     g)
   0))

(define (gua-name gua)
  (hash-ref (gua-info gua) 'gua-name)
  )

(module+ test

  (require rackunit rackunit/text-ui)

  (check-equal? (gua-name '(1 0 1 1 1 0)) "革")
  (check-equal? (gua-name '(1 1 1 0 0 1)) "大畜")

  )
