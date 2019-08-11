#lang racket
(require 2htdp/image
         2htdp/universe
         "classes.rkt")

(define WIDTH 600)
(define HEIGHT 600)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT))
(define YAO-WIDTH 100)
(define YAO-HEIGHT 15)

(define GUA0 (make-gua '(1 1 0 0 0 1) CENTER-X CENTER-Y YAO-WIDTH YAO-HEIGHT BG-COLOR 'cyan))

(define (render/yao yao bg)
  (place-image (send yao render)
               (get-field x yao) (get-field y yao)
               bg
               ))

(define (render gua)
  (for/fold ([bg MTS])
            ([yao (in-list gua)])
    (render/yao yao bg)
    ))

(define (mouse-handler gua mx my me)
  (cond
    [(mouse=? me "button-down")
     (for/list ([yao (in-list gua)])
       (if (send yao mouse-on? mx my)
           (begin
             (send yao bian)
             yao)
           yao))
     ]
    [else gua]
    )
  )

(big-bang GUA0
          [to-draw render]
          [on-mouse mouse-handler]
          )
