#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(provide string-edit-distance)

(define-ffi-definer define-ed (ffi-lib "editdistance"))

(define-ed edit-distance
  (_fun [vec1 : (_list i _int64)]
        [_uint = (length vec1)]
        [vec2 : (_list i _int64)]
        [_uint = (length vec2)] -> _uint)
  #:c-id edit_distance)

(define (string-edit-distance str-a str-b)
  (define chars-a (string->list str-a))
  (define chars-b (string->list str-b))

  (define ints-a (map char->integer chars-a))
  (define ints-b (map char->integer chars-b))

  (edit-distance ints-a ints-b))
