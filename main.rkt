#lang racket
(require 2htdp/image
         2htdp/universe
         "render.rkt"
         "mouse.rkt"
         "gua.rkt")

(define WIDTH 1200)
(define HEIGHT 800)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
(define YAO-COLOR 'cyan)

(define GUA0 (guapic '(1 1 0 0 0 1)
                     (vector CENTER-X CENTER-Y)
                     YAO-WIDTH))

(define (render gua)
  (render/guapic gua MTS YAO-COLOR BG-COLOR)
  )

(define (mouse-handler gua mx my me)
  (let ([n (mouse-on-yaopic-n? mx my gua)])
    (if n
        (cond
          [(mouse=? me "button-down")
           (struct-copy guapic gua [xiang (zhi-gua (guapic-xiang gua) n)])]
          [else gua]
          )
        gua
        ))
  )

(big-bang GUA0
          [to-draw render]
          [on-mouse mouse-handler]
          )
