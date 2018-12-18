#lang racket

(require gua/contract)

(provide (contract-out
          [gua (hash/c (listof zero-or-one/c) hash?)]))

(define gua
  (hash
   '(1 1 1) (hash 'name '乾 'xiang '天 'pre-num 1 'post-num 6 'pre-pos 'south 'post-pos 'north-west)
   '(0 1 0) (hash 'name '坎 'xiang '水 'pre-num 6 'post-num 1 'pre-pos 'west 'post-pos 'north)
   '(0 0 1) (hash 'name '艮 'xiang '山 'pre-num 7 'post-num 8 'pre-pos 'north-west 'post-pos 'north-east)
   '(1 0 0) (hash 'name '震 'xiang '雷 'pre-num 4 'post-num 3 'pre-pos 'north-east 'post-pos 'east)
   '(0 1 1) (hash 'name '巽 'xiang '风 'pre-num 5 'post-num 4 'pre-pos 'south-west 'post-pos 'south-east)
   '(1 0 1) (hash 'name '离 'xiang '火 'pre-num 3 'post-num 9 'pre-pos 'east 'post-pos 'south)
   '(0 0 0) (hash 'name '坤 'xiang '地 'pre-num 8 'post-num 2 'pre-pos 'north 'post-pos 'south-west)
   '(1 1 0) (hash 'name '兑 'xiang '泽 'pre-num 2 'post-num 7 'pre-pos 'south-east 'post-pos 'west)
   ))

(define xing
  (hash
   'jin (hash 'name '金
              'sheng 'shui
              'ke 'mu
              'pos 'west
              'tiangan '(庚 辛))
   'mu (hash 'name '木
              'sheng 'huo
              'ke 'tu
              'pos 'east
              'tiangan '(甲 乙))
   'shui (hash 'name '水
              'sheng 'mu
              'ke 'huo
              'pos 'north
              'tiangan '(壬 癸))
   'huo (hash 'name '火
              'sheng 'tu
              'ke 'jin
              'pos 'south
              'tiangan '(丙 丁))
   'tu (hash 'name '土
              'sheng 'jin
              'ke 'shui
              'pos 'center
              'tiangan '(戊 己))
   ))

(define tiangan
  '(甲 乙 丙 丁 戊 己 庚 辛 壬 癸))

(define dizhi
  '(子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥))

(define 纳甲
  '())
