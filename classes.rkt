#lang racket

(require 2htdp/image
         2htdp/universe
         "gua.rkt")
(provide yao%
         gua64%)

(define yao%
  (class object%
    (init-field [width 100]
                [height 15]
                [gap-color 'white]
                [color 'cyan]
                [x 0]
                [y 0]
                [n 0]
                )

    (super-new)

    (define YANG-IMG
      (rectangle width height 'solid color)
      )

    (define YIN-IMG
      (overlay (rectangle (* width 1/5) (+ height 1) 'solid gap-color)
               YANG-IMG))

    (define/public (->image)
      (if (zero? n)
          YIN-IMG
          YANG-IMG))

    (define/public (render bg)
      (place-image (->image)
                   x y
                   bg)
      )

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

    (define GUA-GAP
      (* yao-height 1/3))
    
    (define/public (gua-height)
      (+ (* yao-height 6)
         (* GUA-GAP 5))
      )

    (define BOTTOM-Y
      (+ y
         (* (gua-height) 1/2))
      )

    (define/public (yao-ys)
      (for/list ([i (in-range (length yaos))])
        (- BOTTOM-Y
           (+
            (* i
               (* yao-height 4/3))
            (/ yao-height 2)))))

    (define/public (make-yaos)
      (for/list ([yao-n (in-list yaos)]
                 [yao-y (in-list (yao-ys))])
          (new yao% [n yao-n]
               [x x]
               [y yao-y]
               [width width]
               [height yao-height]
               [gap-color gap-color]
               [color yao-color])))

    (define/public (render bg)
      (for/fold ([bg bg])
                ([yao (in-list (make-yaos))])
        (send yao render bg)))

    ;; integer? integer? boolean?
    (define/public (mouse-on? mx my)
      (let ([top (- y (/ (gua-height) 2))]
            [bottom (+ y (/ (gua-height) 2))]
            [left (- x (/ width 2))]
            [right (+ x (/ width 2))]
            )
        (and (< left mx right)
             (< top my bottom)))
      )

    (define/public (mouse-on-yao? mx my)
      (let helper ([yao-lst (make-yaos)]
                   [i 1])
        (if (empty? yao-lst)
            #f
            (if (send (first yao-lst) mouse-on? mx my)
                i
                (helper (rest yao-lst) (add1 i))))))

    (define/public (zhi-gua . i)
      (set! yaos
            (for/list ([yao-n (in-list yaos)]
                       [idx (in-range 1 7)])
              (if (member idx i)
                  (yao-bian yao-n)
                  yao-n))))

    ))
