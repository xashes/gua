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

(: zong-gua (-> Gua Gua))
(define (zong-gua g)
  (assert ((inst reverse Yao) g) gua?))
(module+ test
  (check-equal? (zong-gua '(0 0 0 0 1 0))
                '(0 1 0 0 0 0))
  )

(: cuo-gua (-> Gua Gua))
(define (cuo-gua g)
  (assert (map yao-bian g) gua?))
(module+ test
  (check-equal? (cuo-gua '(1 0 1 1 1 0))
                '(0 1 0 0 0 1))
  (check-equal? (cuo-gua '(1 0 1))
                '(0 1 0))
  )

(: jiao-gua (-> Gua64 Gua8))
(define (jiao-gua g64)
  (assert
   (for/list ([i : Integer (in-list '(2 3 4))])
     (assert (list-ref g64 i) yao?))
   gua8?)
  )
(module+ test
  (check-equal? (jiao-gua '(1 1 1 0 0 0))
                '(1 0 0))
  )

(: hu-gua (-> Gua64 Gua8))
(define (hu-gua g64)
  '(1 0 1))

(: jiaohu-gua (-> Gua64 Gua64))
(define (jiaohu-gua g64)
  g64)

(: zhi-gua (-> Gua YaoPosn * Gua))
(define (zhi-gua g . yp)
  g)
