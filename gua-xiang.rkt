#lang racket

;; interface
(provide
 (contract-out
  [yao-xiang? (-> integer? boolean?)]
  [gua-xiang? (-> (listof integer?) boolean?)]
  [gua-xiang8? (-> (listof integer?) boolean?)]
  [gua-xiang64? (-> (listof integer?) boolean?)]
  [yao-bian (-> yao-xiang? yao-xiang?)]
  [zong-gua (-> gua-xiang? gua-xiang?)]
  [cuo-gua (-> gua-xiang? gua-xiang?)]
  [jiao-gua (-> gua-xiang64? gua-xiang8?)]
  [hu-gua (-> gua-xiang64? gua-xiang8?)]
  [jiaohu-gua (-> gua-xiang64? gua-xiang64?)]
  [zhi-gua (->* (gua-xiang?) () #:rest yao-posns? gua-xiang?)]
  [yao-posn? (-> integer? boolean?)]
  [yao-posns? (-> (listof integer?) boolean?)]
  ))
;; end of interface

;; gua-xiang64 ::= gua-xiang8 . gua-xiang8
;; gua-xiang8 ::= (list yao yao yao)
;; yao ::= 0 | 1

(define (yao-xiang? i)
  (and (integer? i)
       (or (zero? i)
           (= i 1))))

(define (gua-xiang8? lst)
  (and (= (length lst) 3)
       (andmap yao-xiang? lst)))

(define (gua-xiang64? lst)
  (and (= (length lst) 6)
       (andmap yao-xiang? lst)))

(define (gua-xiang? lst)
  (or (gua-xiang8? lst)
      (gua-xiang64? lst)))

(define (yao-posn? i)
  (and (>= i 1)
       (<= i 6)))

;; TODO check for no duplications
(define (yao-posns? lst)
  (andmap yao-posn? lst))

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

(define (zhi-gua gua . yaos)
  (for/list ([yao (in-list gua)]
             [idx (in-range 1 7)])
    (if (member idx yaos)
        (yao-bian yao)
        yao)))

;; gua-xiang64 -> gong

;; gong -> gua-xiang64
;; 生成本宫的归魂卦
;; 生成本宫的游魂卦

;; gua-xiang64 -> (U gong boolean?)
;; 判断是否为某宫的游魂卦，是则返回宫名，否则返回 #f

;; gua-xiang64 -> (U gua-xiang64 boolean?)
;; 返回上、下经对应卦，如果不存在，则返回 #f


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
  (check-equal? (zhi-gua '(0 0 0 1 1 1) 3)
                '(0 0 1 1 1 1))
  (check-equal? (zhi-gua '(0 0 0 1 1 1) 3 5 6)
                '(0 0 1 1 0 0))

  (check-true (yao-xiang? 1))
  (check-true (yao-xiang? 0))
  (check-false (yao-xiang? 2))
  (check-false (yao-xiang? 'a))

  (check-true (gua-xiang8? '(1 1 1)))
  (check-false (gua-xiang8? '(1 1 2)))

  (check-true (gua-xiang64? '(1 1 1 0 0 1)))
  (check-false (gua-xiang64? '(1 1 1 0 0 6)))


  )
