#lang racket

;; interface
(provide
 (contract-out
  [yao-bian (-> yao? yao?)]
  [zong-gua (-> gua? gua?)]
  [cuo-gua (-> gua? gua?)]
  [jiao-gua (-> gua64? gua8?)]
  [hu-gua (-> gua64? gua8?)]
  [jiaohu-gua (-> gua64? gua64?)]
  ))
;; end of interface

;; gua64 ::= gua8 . gua8
;; gua8 ::= (list yao yao yao)
;; yao ::= 0 | 1

(define (yao? i)
  (and (number? i)
       (or (zero? i)
           (= i 1))))

(define (gua8? lst)
  (and (= (length lst) 3)
       (andmap yao? lst)))

(define (gua64? lst)
  (and (= (length lst) 6)
       (andmap yao? lst)))

(define (gua? lst)
  (or gua8? gua64?))

(define (yao-bian yao)
  (if (zero? yao) 1 0))

(define (zong-gua gua)
  (reverse gua))

(define (cuo-gua gua)
  (map yao-bian gua)
  )

(define (jiao-gua gua)
  (for/list ([i (in-list '(3 4 5))])
    (list-ref gua (sub1 i)))
  )

(define (hu-gua gua)
  (for/list ([i (in-list '(2 3 4))])
    (list-ref gua (sub1 i))))

(define (jiaohu-gua gua)
  (append (hu-gua gua) (jiao-gua gua)))


(module+ test

  (require rackunit rackunit/text-ui)

  (check-equal? (zong-gua '(0 0 0 0 1 0))
                '(0 1 0 0 0 0))
  (check-equal? (cuo-gua '(1 0 1 1 1 0))
                '(0 1 0 0 0 1))
  (check-equal? (jiao-gua '(1 1 1 0 0 0))
                '(1 0 0))
  (check-equal? (hu-gua '(1 1 1 0 0 0))
                '(1 1 0))
  (check-equal? (jiaohu-gua '(1 1 1 0 0 0))
                '(1 1 0 1 0 0))
  (check-equal? (jiaohu-gua '(0 0 0 1 1 1))
                '(0 0 1 0 1 1))

  (check-true (yao? 1))
  (check-true (yao? 0))
  (check-false (yao? 2))
  (check-false (yao? 'a))

  (check-true (gua8? '(1 1 1)))
  (check-false (gua8? '(1 1 2)))

  (check-true (gua64? '(1 1 1 0 0 1)))
  (check-false (gua64? '(1 1 1 0 0 6)))

  )
