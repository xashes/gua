#lang racket

(require 2htdp/image
         2htdp/universe)

(require racket/date)

(define WIDTH 300)
(define HEIGHT 300)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BG-COLOR 'white)
(define MTS (empty-scene WIDTH HEIGHT BG-COLOR))

(define START-TIME (current-seconds))
(define TIME-RATE 1/60)
(define STATUS 'stop)

(module+ test
  (require rackunit rackunit/text-ui)
  )

(struct hour (s m h) #:transparent)

(define/contract (seconds->hour secs)
  (-> real? hour?)
  (define-values (h s-remain) (quotient/remainder secs 3600))
  (define-values (m s) (quotient/remainder s-remain 60))
  (hour s m h)
  )
(module+ test
  (check-equal? (seconds->hour 10)
                (hour 10 0 0))
  (check-equal? (seconds->hour 60)
                (hour 0 1 0))
  (check-equal? (seconds->hour 80)
                (hour 20 1 0))
  (check-equal? (seconds->hour 3600)
                (hour 0 0 1))
  (check-equal? (seconds->hour 3601)
                (hour 1 0 1))
  (check-equal? (seconds->hour 3661)
                (hour 1 1 1))
  )

(define/contract (hour->string hours)
  (-> hour? string?)
  (define-values (_ s m h) (vector->values (struct->vector hours)))
  (format "~a : ~a : ~a" h m s)
  )
(module+ test
  (check-equal?
   (hour->string (hour 10 20 60))
   "60 : 20 : 10")
  )

;; WS ::= real?
(define/contract (tick ws)
  (-> real? real?)
  (match STATUS
    ['stop ws]
    ['pause ws]
    ['normal (add1 ws)]
    ['reset 0]
    )
  )

(define/contract (timer->image ws)
  (-> real? image?)
  (text (hour->string (seconds->hour ws)) 36 'black)
  )

(define/contract (render/timer ws)
  (-> real? image?)
  (place-image (timer->image ws)
               CENTER-X CENTER-Y
               MTS)
  )

(define/contract (key-handler ws ke)
  (-> real? key-event? real?)
  (cond
    [(key=? ke "r") (set! STATUS 'reset)]
    [(key=? ke "p") (set! STATUS 'pause)]
    [(key=? ke "s") (set! STATUS 'stop)]
    [(key=? ke " ") (set! STATUS 'normal)]
    )
  ws
  )

(define/contract (timer ws)
  (-> real? real?)
  (big-bang ws
            [to-draw render/timer]
            [on-tick tick TIME-RATE]
            [on-key key-handler]
            )
  )

(module+ main

  (timer 0)
  )
