#lang racket
(require 2htdp/image
         2htdp/universe
         "classes.rkt")

(define WIDTH 600)
(define HEIGHT 600)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
<<<<<<< HEAD
(define MTS (empty-scene WIDTH HEIGHT))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
=======
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))
(define YAO-WIDTH 100)
(define YAO-HEIGHT 15)
>>>>>>> origin/master

(define (make-gua lon mid-x bottom-y)
  (for/list ([yao-n (in-list lon)]
             [i (in-range (length lon))]
             )
    (let ([yao-y (- bottom-y
                    (+
                     (* i
                        (* YAO-HEIGHT 4/3))
                     (/ YAO-HEIGHT 2)))])
      (new yao% [n yao-n] [x mid-x] [y yao-y] [width YAO-WIDTH] [height YAO-HEIGHT]
           [gap-color BG-COLOR]))
    ))

<<<<<<< HEAD
(define GUA0 (make-gua '(1 1 0 0 0 1) CENTER-X HEIGHT))
=======
(define GUA0 (send (new gua64% [width YAO-WIDTH]
                        [yao-height YAO-HEIGHT]
                        [gap-color BG-COLOR]
                        [yao-color 'cyan]
                        [x CENTER-X]
                        [y CENTER-Y]
                        [yaos '(1 1 0 0 0 1)]
                        ) make-yaos)
  )
>>>>>>> origin/master

(define (render/yao yao bg)
  (place-image (send yao render)
               (get-field x yao) (get-field y yao)
               bg
               ))

(define (render/gua gua bg)
  (for/fold ([bg bg])
            ([yao (in-list gua)])
    (render/yao yao bg)
    ))

(define (render gua)
  (render/gua gua MTS)
  )

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
