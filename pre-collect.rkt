#lang racket/base

(require net/url)

(require "openai-request.rkt"
         "api-data.rkt")

(define models
  '("gpt-4o"
    "gpt-4o-mini"
    "claude-3-5-sonnet"
    "deepseek-chat"
    "deepseek-coder"
    "gemini-1.5-pro-001"
    "gemini-1.5-flash-001"
    "claude-3-haiku"
    "claude-3-sonnet"
    "claude-3-opus"
    "gemini-1.5-pro-exp-0827"
    "gemini-1.5-flash-exp-0827"))

(define test-prompt "请简要介绍 Transformer 架构")

(define (collect-model-response models test-prompt)
  (define-values (openai-base openai-uri) (openai-url-convert (string->url openai-base-url)))
  
  (for/hash ([model (in-list models)])
    (displayln (format "正在接受模型 ~a 的回复" model))
    (values model
            (list (get-openai-reply model test-prompt
                                    #:openai-base openai-base
                                    #:openai-uri openai-uri
                                    #:api-key api-key)))))

(define pre-result (collect-model-response models test-prompt))

(with-output-to-file "pre-result.data"
  (lambda () (write pre-result)))