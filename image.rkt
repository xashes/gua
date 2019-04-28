#lang racket

(require 2htdp/image
         "gua.rkt")

(provide
 (contract-out
  [yao-image (-> yao? image?)]
  [gua-image (-> gua? image?)]
  ))

(define YAO-WIDTH 100)
(define YAO-HEIGHT 10)
(define YAO-COLOR 'mediumcyan)
(define YIN-GAP (* YAO-WIDTH 1/12))
(define YAO-GAP (* YIN-GAP 0.8))
(define GAP-COLOR (color 0 0 0 0))
(define YIN-WIDTH (/ (- YAO-WIDTH YIN-GAP) 2))

(define (yao-gap-image)
  (rectangle YAO-WIDTH YAO-GAP 'outline GAP-COLOR))

(define (yang-image)
  (rectangle YAO-WIDTH YAO-HEIGHT "solid" YAO-COLOR))

(define (yin-image)
  (let ([half (rectangle YIN-WIDTH YAO-HEIGHT "solid" YAO-COLOR)]
        [gap (rectangle YIN-GAP YAO-HEIGHT 'outline GAP-COLOR)]
        )
    (beside half gap half)
    ))

(define (yao-image yao)
  (if (zero? yao)
      (above (yao-gap-image) (yin-image))
      (above (yao-gap-image) (yang-image))))

(define (gua-image gua)
  (let ([yao-imgs (map yao-image gua)])
    (apply above (reverse yao-imgs))
    ))


(module+ test

  (require rackunit rackunit/text-ui)

  (gua-image '(1 0 0 0 1 1))

  )
