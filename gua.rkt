#lang racket

(require 2htdp/image
         2htdp/universe
         gua/data
         gua/contract)

(provide (contract-out
          [gua-name (-> (listof zero-or-one/c) string?)]
          [random-gua (->* () (3-or-6/c) (listof zero-or-one/c))]
          [yao-bian (-> zero-or-one/c zero-or-one/c)]
          [zong-gua (-> (listof zero-or-one/c) (listof zero-or-one/c))]
          [cuo-gua (-> (listof zero-or-one/c) (listof zero-or-one/c))]
          [hu-gua (-> (listof zero-or-one/c) (listof zero-or-one/c))]
          [jiao-gua (-> (listof zero-or-one/c) (listof zero-or-one/c))]
          [jiaohu-gua (-> (listof zero-or-one/c) (listof zero-or-one/c))]
          ))

(define (gua-name code)
  (symbol->string
   (hash-ref (hash-ref gua code) 'name)))

(define (random-gua [n 3])
  (for/list ([i (in-range n)])
    (random 2)))

(define (yao-bian yao)
  (if (zero? yao) 1 0))

(define (zong-gua code)
  (-> (listof zero-or-one/c) (listof zero-or-one/c))
  (reverse code)
  )

(define (cuo-gua code)
  (map yao-bian code)
  )

(define (hu-gua code)
  (for/list ([i (in-list '(2 3 4))])
    (list-ref code (- i 1)))
  )

(define (jiao-gua code)
  (for/list ([i (in-list '(3 4 5))])
    (list-ref code (- i 1)))
  )

(define (jiaohu-gua code)
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
