#lang racket
(require 2htdp/image
         2htdp/universe
         "render.rkt"
         "mouse.rkt"
         "gua.rkt")
(provide WIDTH
         HEIGHT
         BG-COLOR
         YAO-COLOR)

(define WIDTH 1200)
(define HEIGHT 800)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))
(define YAO-WIDTH 200)
(define YAO-HEIGHT (* YAO-WIDTH 0.15))
(define YAO-COLOR 'cyan)
(define YAOCI-COLOR 'black)

(struct worldstate (gua yaoci) #:transparent #:mutable)

(define WS0 (worldstate (guapic '(1 1 0 0 0 1)
                                (vector CENTER-X CENTER-Y)
                                YAO-WIDTH)
                        null))
(require racket/struct)

(define (render ws)
  (define pics (struct->list ws))
  (for/fold ([bg MTS])
            ([pic (in-list pics)])
    (render/pic pic bg))
  )

(define (mouse-handler ws mx my me)
  (define-values (_ gua yaoci)
    (vector->values (struct->vector ws)))
  (let ([n (mouse-on-yaopic-n? mx my gua)])
    (if n
        (cond
          [(mouse=? me "button-down")
           (let ([new-gua (struct-copy guapic gua [xiang (zhi-gua (guapic-xiang gua) n)])])
             (worldstate
              new-gua
              (make-yaoci-textpic new-gua n YAOCI-COLOR)))]
          [(mouse=? me "move")
           (worldstate
            gua
            (make-yaoci-textpic gua n YAOCI-COLOR))]
          [else ws]
          )
        (worldstate
         gua
         #f)
        ))
  )

(module+ main

  (big-bang WS0
            [to-draw render]
            [on-mouse mouse-handler]
            )
  )
