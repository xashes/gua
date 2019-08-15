#lang racket
(require 2htdp/image
         2htdp/universe
         "classes.rkt")

(define WIDTH 600)
(define HEIGHT 600)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))

(define GUA0 (new gua64% [width YAO-WIDTH]
                        [gap-color BG-COLOR]
                        [yao-color 'cyan]
                        [x CENTER-X]
                        [y CENTER-Y]
                        [xiang '(1 1 0 0 0 1)]
                        )
  )

(define (render gua)
  (send gua render MTS)
  )

(define (mouse-handler gua mx my me)
  (cond
    [(mouse=? me "button-down")
     (let ([i (send gua mouse-on-yao? mx my)])
       (if i
           (begin
             (send gua zhi-gua i)
             gua
             )
           gua))]
    [else gua]
    )
  )

(big-bang GUA0
          [to-draw render]
          [on-mouse mouse-handler]
          )
