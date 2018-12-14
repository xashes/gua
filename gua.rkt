#lang racket

(require 2htdp/image
         2htdp/universe)

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
(define (zero-or-one/c n)
  (or (zero? n) (= n 1)))

(define/contract (gua-name code)
  (-> (listof zero-or-one/c) string?)
  (symbol->string
   (hash-ref (hash-ref gua code) 'name)))

(define/contract (random-gua [n 3])
  (->* () (number?) (listof zero-or-one/c))
  (for/list ([i (in-range n)])
    (random 2)))

(define/contract (yao-bian yao)
  (-> zero-or-one/c zero-or-one/c)
  (if (zero? yao) 1 0))

(define/contract (zong-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (reverse code)
  )

(define/contract (cuo-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (map yao-bian code)
  )

(define/contract (hu-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (for/list ([i (in-list '(2 3 4))])
    (list-ref code (- i 1)))
  )

(define/contract (jiao-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (for/list ([i (in-list '(3 4 5))])
    (list-ref code (- i 1)))
  )

(define/contract (jiaohu-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (for/list ([i (in-list '(1 2 3 2 3 4))])
    (list-ref code i))
  )

(define (fangtu)
  (for ([i (in-range 8 0 -1)])
    (for ([j (in-range 8 0 -1)])
      (display (list i j))
      )
    (newline))
  )

(define fuxi-gua
  '((1 1 1)
    (0 1 1)
    (0 1 0)
    (0 0 1)
    (0 0 0)
    (1 0 0)
    (1 0 1)
    (1 1 0)
    )
  )

(define wenwang-gua
  '((1 0 1)
    (0 0 0)
    (1 1 0)
    (1 1 1)
    (0 1 0)
    (0 0 1)
    (1 0 0)
    (0 1 1)
    ))

(define gua-orient
  '("南" "西" "北" "东"))


(define (txt-pic txt)
  (text txt 26 "black"))


(define (place-and-turn txt background)
  (rotate 45
          (overlay/align "center" "top"
                         (above
                          (rectangle 5 5 "solid" "lightblue")
                          (txt-pic txt))
                         background)))
(define (background)
  (define (place-and-turn txt background)
    (rotate 90
            (overlay/align "center" "top"
                           (above
                            (rectangle 6 18 "solid" "lightblue")
                            (text txt 18 "black"))
                           background)))
  (foldl place-and-turn
         (circle 80 "solid" "lightblue")
         gua-orient
         ))

;; (define (place-all-text gua-type)
;;   (foldl place-and-turn
;;          (overlay
;;           (background)
;;           (circle 120 "solid" "black"))
;;          (map gua-name gua-type)
;;          )
;;   )

(define (place-all-text gua-type)
  (for/fold ([bg (overlay
                  (background)
                  (circle 120 "solid" "lightblue"))])
            ([txt (in-list (map gua-name gua-type))])
            (place-and-turn txt bg)))

(define fuxi-gua-pic
  (place-all-text fuxi-gua))

(define wenwang-gua-pic
  (place-all-text wenwang-gua))
