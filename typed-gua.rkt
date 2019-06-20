#lang typed/racket

; Interface
(provide Yao
         Gua
         Gua8
         Gua64
         YaoPosn
         yao-bian)

(define-type Yao (U 0 1))
(define-predicate yao? Yao)

(module+ test

  (require typed/rackunit typed/rackunit/text-ui)

  (check-true (yao? 0))
  (check-true (yao? 1))
  (check-false (yao? 2))

  )

(define-type Gua (U Gua8 Gua64))
(define-type Gua8 (List Yao Yao Yao))
(define-type Gua64 (List Yao Yao Yao Yao Yao Yao))
(define-predicate gua? Gua)
(define-predicate gua8? Gua8)
(define-predicate gua64? Gua64)

(module+ test
  (define qian8 '(1 1 1))
  (define zhen8 '(1 0 0))
  (define yi '(1 0 0 0 0 1))
  (define tun '(1 0 0 0 1 0))
  (check-true (gua8? qian8))
  (check-false (gua8? yi))
  (check-true (gua64? tun))
  (check-false (gua64? zhen8))
  (check-true (gua? qian8))
  (check-true (gua? yi))
  (check-false (gua? '(0 1 0 1)))
  )

(define-type YaoPosn (U 1 2 3 4 5 6))

(: yao-bian (-> Yao Yao))
(define (yao-bian y)
  (if (= y 0) 1 0)
  )
(module+ test
  (check-equal? (yao-bian 0) 1)
  (check-equal? (yao-bian 1) 0)
  )
