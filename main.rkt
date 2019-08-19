#lang racket
(require 2htdp/image
         2htdp/universe
         "render.rkt"
         "mouse.rkt"
         "gua.rkt"
         "render-constants.rkt")

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
              (make-yaoci-textpic new-gua n)))]
          [(mouse=? me "move")
           (worldstate
            gua
            (make-yaoci-textpic gua n))]
          [else ws]
          )
        (worldstate
         gua
         #f)
        ))
  )

(define/contract (tick ws)
  (-> worldstate? worldstate?)
  ws
  )

(module+ main

  (big-bang WS0
            [to-draw render]
            [on-mouse mouse-handler]
            )
  )
