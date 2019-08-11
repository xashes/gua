#lang racket

(require 2htdp/image
         2htdp/universe
         "gua.rkt")
(provide yao%
         make-gua)

(define yao%
  (class object%
    (init-field [width 100]
                [height 15]
                [gap-color 'white]
                [yao-color 'cyan]
                [x 0]
                [y 0]
                [n 0]
                )

    (super-new)

    (define/private (render/yang)
      (rectangle width height 'solid yao-color)
      )

    (define/private (render/yin)
      (overlay (rectangle (* width 1/5) (+ height 1) 'solid gap-color)
               (render/yang)))

    (define/public (render)
      (if (zero? n)
          (render/yin)
          (render/yang)))

    (define/public (mouse-on? mx my)
      (let ([left (- x (/ width 2))]
            [right (+ x (/ width 2))]
            [top (- y (/ height 2))]
            [bottom (+ y (/ height 2))]
            )
        (and (< left mx right)
             (< top my bottom))))

    (define/public (bian)
      (set! n (yao-bian n)))
    ))

(define (make-gua lon mid-x bottom-y yao-width yao-height gap-color yao-color)
  (for/list ([yao-n (in-list lon)]
             [i (in-range (length lon))]
             )
    (let ([yao-y (- bottom-y
                    (+
                     (* i
                        (* yao-height 4/3))
                     (/ yao-height 2)))])
      (new yao% [n yao-n] [x mid-x] [y yao-y] [width yao-width] [height yao-height]
           [gap-color gap-color] [yao-color yao-color]))
    ))
