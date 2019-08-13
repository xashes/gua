#lang racket

(require 2htdp/image
         2htdp/universe
         "gua.rkt")
(provide yao%)

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

(define gua64%
  (class object%
    (init-field [width 200]
                [yao-height 30]
                [gap-color 'white]
                [yao-color 'cyan]
                [x 0]
                [y 0]
                [yaos '(1 1 1 1 1 1)])
    (super-new)
    ))
