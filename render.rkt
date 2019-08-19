#lang racket

(require 2htdp/image
         2htdp/universe
         "gua-info.rkt"
         "gua.rkt")
(require "render-constants.rkt")

(provide (contract-out [struct guapic
                         ([xiang gua?]
                          [posn (vectorof real?)]
                          [width real?])]
                       [struct (yaopic guapic)
                         ([xiang yao?]
                          [posn (vectorof real?)]
                          [width real?]
                          [color (or/c symbol? color?)]
                          [gap-color (or/c symbol? color?)])]
                       [struct textpic
                         ([content string?]
                          [posn (vectorof real?)]
                          [font-size (and/c integer? (between/c 1 255))]
                          [font-color (or/c symbol? color?)])]
                       ))

(provide render/guapic
         get-edges/guapic
         guapic->yaopic-list
         make-yaoci-textpic
         render/textpic
         render/pic)

(define GAP-COLOR BG-COLOR)

;; structs for render
(struct guapic (xiang posn width) #:transparent)
(struct yaopic guapic (color gap-color) #:transparent)
(struct textpic (content posn font-size font-color) #:transparent)

(module+ test
  (require rackunit rackunit/text-ui)

  (define guapic0 (guapic '(1 1 0 0 0 1)
                    #(200 300)
                    200))
  (define yaopic0 (yaopic 0
                    #(100 80)
                    200
                    YAO-COLOR
                    GAP-COLOR))
  (define yaopic1 (struct-copy yaopic yaopic0 [xiang #:parent guapic 1]))
  )

;; private
(define/contract (get-yaopic-height w)
  (-> real? real?)
  (* w 15/100)
  )
(module+ test
  (check-= (get-yaopic-height 200) 30 0.01)
  )

;; private
(define/contract (get-yaopic-gap w)
  (-> real? real?)
  (* (get-yaopic-height w) 1/3)
  )
(module+ test
  (check-= (get-yaopic-gap 200) 10 0.01)
  )

;; private
(define/contract (get-guapic-height w)
  (-> real? real?)
  (+ (* (get-yaopic-height w) 6)
     (* (get-yaopic-gap w) 5)))
(module+ test
  (check-= (get-guapic-height 200) 230 0.01)
  )

(define/contract (get-height g [y-or-g #f])
  (->* (guapic?)
       ((or/c symbol? #f))
       real?)
  (let ([w (guapic-width g)])
    (cond
      [(eq? y-or-g 'yao) (get-yaopic-height w)]
      [(eq? y-or-g 'gua) (get-guapic-height w)]
      [else
       (if (yaopic? g)
           (get-yaopic-height w)
           (get-guapic-height w))])))
(module+ test
  (check-= (get-height guapic0) 230 0.01)
  (check-= (get-height yaopic1) 30 0.01)
  (check-= (get-height guapic0 'yao) 30 0.01)
  )

(define/contract (get-edges/guapic g)
  (-> guapic? (vectorof real?))
  (let-values ([(x y) (vector->values (guapic-posn g))])
    (let* ([width (guapic-width g)]
           [height (get-height g)]
           [left (- x (/ width 2))]
           [right (+ x (/ width 2))]
           [top (- y (/ height 2))]
           [bottom (+ y (/ height 2))]
           )
      (vector left right top bottom)))
  )
(module+ test
  (check-equal? (get-edges/guapic guapic0)
                #(100 300 185 415))
  )

(define/contract (get-bottom-y g)
  (-> guapic? real?)
  (let* ([p (guapic-posn g)]
         [y (vector-ref p 1)])
    (+ y
       (/ (get-height g) 2))))
(module+ test
  (check-= (get-bottom-y guapic0) 415 0.01)
  )

(define/contract (guapic->yaopic-ys g)
  (-> guapic? (listof real?))
  (let* ([xiang (guapic-xiang g)]
         [w (guapic-width g)]
         [yh (get-yaopic-height w)]
         [by (get-bottom-y g)]
         )
    (for/list ([i (in-range (length xiang))])
      (- by
         (+ (* i
               (* yh 4/3))
            (/ yh 2))))))
(module+ test
  (check-equal? (guapic->yaopic-ys guapic0)
                (reverse '(200 240 280 320 360 400))))

(define/contract (guapic->yaopic-list g [color YAO-COLOR] [gap-color GAP-COLOR])
  (->* (guapic?) ((or/c symbol? color?) (or/c symbol? color?)) (listof yaopic?))
  (for/list ([xiang (in-list (guapic-xiang g))]
             [y (in-list (guapic->yaopic-ys g))])
    (let ([x (vector-ref (guapic-posn g) 0)]
          [w (guapic-width g)])
      (yaopic xiang (vector x y) w color gap-color))))
(module+ test
  (check-equal? (guapic->yaopic-list guapic0 YAO-COLOR GAP-COLOR)
                (for/list ([y (in-list (reverse '(200 240 280 320 360 400)))]
                           [xiang (in-list (guapic-xiang guapic0))])
                  (yaopic xiang (vector 200 y) 200 YAO-COLOR GAP-COLOR)))
  )

(define/contract (get-yaopic-n g n)
  (-> guapic? yao-posn? yaopic?)
  (list-ref (guapic->yaopic-list g) (sub1 n))
  )
(module+ test
  (check-equal? (get-yaopic-n guapic0 2)
                (yaopic 1 #(200 360) 200 YAO-COLOR GAP-COLOR))
  )

(define/contract (yaopic->image yr)
  (-> yaopic? image?)
  (let-values ([(s xiang _ w c gc)
                (vector->values (struct->vector yr))])
    (let* ([h (get-yaopic-height w)]
           [yang (rectangle w h 'solid c)])
      (if (zero? xiang)
          (overlay (rectangle (* w 1/5) (+ h 1) 'solid gc)
                   yang)
          yang
          ))))
(module+ test
  (check-equal? (yaopic->image yaopic0)
                (overlay (rectangle 40 31 'solid GAP-COLOR)
                         (rectangle 200 (get-yaopic-height 200)
                                    'solid
                                    YAO-COLOR)))
  (check-equal? (yaopic->image yaopic1)
                (rectangle 200 30 'solid YAO-COLOR))
  )

(define/contract (render/yaopic yr bg)
  (-> yaopic? image? image?)
  (let-values ([(x y) (vector->values (guapic-posn yr))])
    (place-image (yaopic->image yr)
                 x y
                 bg)))
(module+ test
  (define WIDTH 400)
  (define HEIGHT 400)
  (define BG-COLOR GAP-COLOR)
  (define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

  (check-equal? (render/yaopic yaopic0 MTS)
                (place-image (yaopic->image yaopic0)
                             100 80
                             MTS))
  )

(define/contract (render/guapic g bg [c YAO-COLOR] [gap-c GAP-COLOR])
  (->* (guapic? image?)
       ((or/c symbol? color?) (or/c symbol? color?))
       image?)
  (for/fold ([bg bg])
            ([yao (in-list (guapic->yaopic-list g c gap-c))])
    (render/yaopic yao bg)))
(module+ test
  (check-equal? (render/guapic guapic0 MTS YAO-COLOR GAP-COLOR)
                (for/fold ([bg MTS])
                          ([xiang (guapic-xiang guapic0)]
                           [y (in-list (guapic->yaopic-ys guapic0))])
                  (render/yaopic (yaopic xiang (vector 200 y) 200 YAO-COLOR GAP-COLOR) bg)))
  )

<<<<<<< HEAD
(define/contract (render/yaoci g yao-n)
  (define yc (get-yaoci g yao-n))
=======
(define/contract (make-yaoci-textpic gua yao-n [font-size YAOCI-SIZE] [font-color YAOCI-COLOR])
  (->* (guapic? yao-posn?)
       ((or/c symbol? color?))
       textpic?)
  (define yaoci (get-yaoci (guapic-xiang gua) yao-n))
  (define-values (x y) (vector->values (guapic-posn (get-yaopic-n gua yao-n))))
  (textpic yaoci (vector x y) font-size font-color)
>>>>>>> 380059c12a00e685013fe8e0fa7f5441ef26061b
  )
(module+ test
  (check-equal? (make-yaoci-textpic guapic0 2)
                (textpic (get-yaoci '(1 1 0 0 0 1) 2)
                         #(200 360)
                         YAOCI-SIZE
                         YAOCI-COLOR))
  )

;; (define/contract (make-guaname-textic gua [font-size GUANAME-SIZE] [font-color GUANAME-COLOR])
;;   )

(define/contract (render/textpic tp bg)
  (-> textpic? image? image?)
  (define-values (_ content posn font-size font-color)
    (vector->values (struct->vector tp)))
  (define-values (x y) (vector->values posn))
  (place-image (text content font-size font-color)
               x y
               bg))
(module+ test
  (check-equal? (render/textpic (make-yaoci-textpic guapic0 4) MTS)
                (place-image (text (get-yaoci '(1 1 0 0 0 1) 4) YAOCI-SIZE YAOCI-COLOR)
                             200 280
                             MTS))
  )

(define/contract (render/pic pic bg)
  (-> any/c image? image?)
  (cond
    [(guapic? pic)
     (render/guapic pic bg)]
    [(textpic? pic)
     (render/textpic pic bg)]
    [else bg]
    ))
