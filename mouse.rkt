#lang racket

(require 2htdp/image
         2htdp/universe
         "render.rkt")

(provide mouse-on-guapic?
         mouse-on-yaopic-n?)

(module+ test
  (require rackunit rackunit/text-ui)

  (define guapic0 (guapic '(1 1 0 0 0 1)
                          #(200 300)
                          200))
  (define yaopic0 (yaopic 0
                          #(100 80)
                          200
                          'cyan
                          'white))
  (define yaopic1 (struct-copy yaopic yaopic0 [xiang #:parent guapic 1]))
  )

(define/contract (mouse-on-guapic? mx my g)
  (-> integer? integer? guapic? boolean?)
  (let-values ([(left right top bottom)
                (vector->values (get-edges/guapic g))])
    (and (<= left mx right)
         (<= top my bottom))))
(module+ test
  (check-true (mouse-on-guapic? 100 186 guapic0))
  (check-true (mouse-on-guapic? 300 415 guapic0))
  (check-false (mouse-on-guapic? 300 416 guapic0))
  (check-false (mouse-on-guapic? 301 186 guapic0))
  (check-false (mouse-on-guapic? 99 186 guapic0))
  (check-false (mouse-on-guapic? 100 184 guapic0))

  (check-false (mouse-on-guapic? 100 48 yaopic0))
  (check-true (mouse-on-guapic? 100 80 yaopic0))
  )

(define/contract (mouse-on-yaopic-n? mx my g)
  (-> integer? integer? guapic? (or/c integer? #f))
  (let helper ([yao-picts (guapic->yaopic-list g)]
               [i 1])
    (if (empty? yao-picts)
        #f
        (if (mouse-on-guapic? mx my (first yao-picts))
            i
            (helper (rest yao-picts) (add1 i))))))
(module+ test
  (check-false (mouse-on-yaopic-n? 99 400 guapic0))
  (check-false (mouse-on-yaopic-n? 100 384 guapic0))
  (check-equal? (mouse-on-yaopic-n? 100 385 guapic0) 1)
  (check-equal? (mouse-on-yaopic-n? 100 375 guapic0) 2)
  (check-equal? (mouse-on-yaopic-n? 100 305 guapic0) 3)
  (check-equal? (mouse-on-yaopic-n? 100 285 guapic0) 4)
  (check-equal? (mouse-on-yaopic-n? 100 230 guapic0) 5)
  (check-equal? (mouse-on-yaopic-n? 100 185 guapic0) 6)
  )
