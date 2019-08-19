#lang racket

(require "gua.rkt"
         json)

(provide (contract-out
          [gua8-data (hash/c gua8? hash?)]))

(define gua8-data
  (hash
   '(1 1 1) (hash 'name '乾 'xiang '天 'pre-num 1 'post-num 6 'pre-pos '南 'post-pos '西北)
   '(0 1 0) (hash 'name '坎 'xiang '水 'pre-num 6 'post-num 1 'pre-pos '西 'post-pos '北)
   '(0 0 1) (hash 'name '艮 'xiang '山 'pre-num 7 'post-num 8 'pre-pos '西北 'post-pos '东北)
   '(1 0 0) (hash 'name '震 'xiang '雷 'pre-num 4 'post-num 3 'pre-pos '东北 'post-pos '东)
   '(0 1 1) (hash 'name '巽 'xiang '风 'pre-num 5 'post-num 4 'pre-pos '西南 'post-pos '东南)
   '(1 0 1) (hash 'name '离 'xiang '火 'pre-num 3 'post-num 9 'pre-pos '东 'post-pos '南)
   '(0 0 0) (hash 'name '坤 'xiang '地 'pre-num 8 'post-num 2 'pre-pos '北 'post-pos '西南)
   '(1 1 0) (hash 'name '兑 'xiang '泽 'pre-num 2 'post-num 7 'pre-pos '东南 'post-pos '西)
   ))

(define xing
  (hash
   '金 (hash 'name '金
              'sheng '水
              'ke '木
              'pos '西
              'tiangan '(庚 辛))
   '木 (hash 'name '木
              'sheng '火
              'ke '土
              'pos '东
              'tiangan '(甲 乙))
   '水 (hash 'name '水
              'sheng '木
              'ke '火
              'pos '北
              'tiangan '(壬 癸))
   '火 (hash 'name '火
              'sheng '土
              'ke '金
              'pos '南
              'tiangan '(丙 丁))
   '土 (hash 'name '土
              'sheng '金
              'ke '水
              'pos 'center
              'tiangan '(戊 己))
   ))

(define tiangan
  '(甲 乙 丙 丁 戊 己 庚 辛 壬 癸))

(define dizhi
  '(子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥))

(define 纳甲
  '())
