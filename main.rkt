#lang racket
(require 2htdp/image
         2htdp/universe
         "render.rkt"
         "mouse.rkt"
         "gua.rkt"
         "render-constants.rkt")

;; 4 pics
;; 如果位置固定，是否只要卦象和指定爻就可以了
(struct worldstate (gua guaname guaci yaoci) #:transparent #:mutable)


(define (make-worldstate gp [yao-n #f])
  (worldstate gp
              (make-guaname-textpic gp)
              (make-guaci-textpic gp)
              (if yao-n
                  (make-yaoci-textpic gp yao-n)
                  #f))
  )

(define WS0 (make-worldstate (guapic '(1 1 0 0 0 1)
                                     (vector CENTER-X CENTER-Y)
                                     YAO-WIDTH)))

(require racket/struct)

(define (render ws)
  (define pics (struct->list ws))
  (for/fold ([bg MTS])
            ([pic (in-list pics)])
    (render/pic pic bg))
  )

(define (mouse-handler ws mx my me)
  (define gua (worldstate-gua ws))
  (let ([n (mouse-on-yaopic-n? mx my gua)])
    (if n
        (cond
          [(mouse=? me "button-down")
           (let ([new-gua (struct-copy guapic gua [xiang (zhi-gua (guapic-xiang gua) n)])])
             (make-worldstate new-gua n))]
          [(mouse=? me "move")
           (make-worldstate gua n)]
          [else ws]
          )
        (make-worldstate gua #f)
        ))
  )

;; use key to change gua to cuo-gua or zong-gua
(define/contract (key-handler ws ke)
  (-> worldstate? key-event? worldstate?)
  ws
  )

(define/contract (tick ws)
  (-> worldstate? worldstate?)
  ws
  )

(big-bang WS0
          [to-draw render]
          [on-mouse mouse-handler]
          )
