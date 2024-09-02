#lang racket/base

(require "string-edit-distance.rkt")

(provide similarity-sorted
         max-similarity)

(define (mean lst) (/ (exact->inexact (apply + lst))
                      (exact->inexact (length lst))))

(define (single-reference-average-distance txts ref)
  (mean
   (map (lambda (s) (string-edit-distance s ref)) txts)))

(define (references-average-distance txts refs)
  (mean
   (map (lambda (r) (single-reference-average-distance txts r))
        refs)))
  
(define (models-similarity txts models-ht)
  (hash-map/copy models-ht
                 (lambda (k v) (values k (references-average-distance txts v)))))

(define (similarity-sorted txts models-ht)
  (let ([similarity (models-similarity txts models-ht)])
    (let ([similarity-list (hash->list similarity)])
      (sort similarity-list
            <
            #:key cdr))))

(define (max-similarity txts models-ht)
  (let ([similarity (similarity-sorted txts models-ht)])
    (let ([first-similar (car similarity)])
      (values (car first-similar)
              (cdr first-similar)))))
