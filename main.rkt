#lang racket/base

(require racket/format
         net/url)

(require "similarity.rkt"
         "openai-request.rkt")

(define pre-data
  (with-input-from-file "pre-result.data"
    (lambda () (read))))

(define (read-line-console-clean)
  (read-line (current-input-port) 'any))

(display "请输入测试 API URL (例: https://api.openai.com/v1）: ")
(define user-openai-url-base (string->url (read-line-console-clean)))

(display "请输入测试 API Key: ")
(define user-api-key (read-line-console-clean))

(display "请输入测试模型名称: ")
(define user-model (read-line-console-clean))

(define-values (user-openai-base user-openai-uri)
  (openai-url-convert user-openai-url-base))

(define user-model-reply
  (get-openai-reply user-model "请简要介绍 Transformer 架构"
                    #:openai-base user-openai-base
                    #:openai-uri user-openai-uri
                    #:api-key user-api-key))

(define result (similarity-sorted (list user-model-reply)
                                  pre-data))

(displayln "=================按可能性从高到低排序=================")

(for ([r (in-list result)])
  (let ([model (car r)]
        [dist (cdr r)])
    (displayln (format "模型=~a 距离=~a"
                       (~a model #:width 32)
                       (~a dist)))))

(displayln "===================按任意键退出程序===================")
(read-line-console-clean)