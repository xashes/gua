#lang racket

(require rackunit
         rackunit/text-ui
         gua/gua)

(define gua-tests
  (test-suite
   "tests for the basic functions"

   (let ([xun '(0 1 1)]
         [zhen '(1 0 0)]
         [fu '(0 1 1 1 1 1)]
         [shike '(1 0 0 1 0 1)]
         )

     (test-case
         "should return gua name"
       (check-equal? (gua-name xun) "巽")
       (check-equal? (gua-name zhen) "震")
       )

     (test-case
         "return zong gua"
       (check-equal? (zong-gua xun) '(1 1 0))
       (check-equal? (zong-gua zhen) '(0 0 1)))

     (test-case
         "return cuo gua"
       (check-equal? (cuo-gua xun) '(1 0 0))
       (check-equal? (cuo-gua zhen) '(0 1 1))
       )

     (test-case
         "下挂至上为互，返回原卦的二，三，四爻"
       (check-equal? (hu-gua fu) '(1 1 1))
       (check-equal? (hu-gua shike) '(0 0 1)))

     (test-case
         "上连至下为交，返回原卦的三，四，五爻"
       (check-equal? (jiao-gua fu) '(1 1 1))
       (check-equal? (jiao-gua shike) '(0 1 0)))

     (test-case
         "互卦为内卦，交卦为外卦"
       (check-equal? (jiaohu-gua fu) '(1 1 1 1 1 1))
       (check-equal? (jiaohu-gua shike) '(0 0 1 0 1 0)))
     )))

(run-tests gua-tests)
