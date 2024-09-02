#lang racket/base

(require json
         net/url-string
         net/http-client
         racket/port
         racket/match)

(provide openai-url-convert
         send-openai-request
         get-openai-reply)

(define (port->string/utf-8 port)
  (bytes->string/utf-8 (port->bytes port)))

(define (openai-url-convert openai-base-url)
  (define openai-base (url-host openai-base-url))
  (define openai-uri
    (url->string
     (struct-copy url openai-base-url
                  [scheme #f]
                  [host #f]
                  [path-absolute? #t]
                  [path (append
                         (url-path openai-base-url)
                         (list
                          (path/param "chat" '())
                          (path/param "completions" '())))])))
  
  (values openai-base openai-uri))

(define (send-openai-request model messages
                             #:openai-base openai-base
                             #:openai-uri openai-uri
                             #:api-key api-key
                             #:temperature [temperature 0.0])
  (define data
    (jsexpr->bytes
     `#hash([model . ,model]
            [temperature . ,temperature]
            [messages . ,messages])))

  (define-values (status response body)
    (http-sendrecv openai-base openai-uri
                   #:data data
                   #:method "POST"
                   #:ssl? 'tls12
                   #:headers `("Content-Type: application/json"
                               ,(format "Authorization: Bearer ~a" api-key))))

  (define js-result
    (string->jsexpr (port->string/utf-8 body)))

  js-result)

(define (get-openai-reply model message
                          #:openai-base openai-base
                          #:openai-uri openai-uri
                          #:api-key api-key
                          #:temperature [temperature 0.0])
  
  (define messages (list `#hash([role . "user"]
                                [content . ,message])))

  (define resp (send-openai-request model messages
                                    #:openai-base openai-base
                                    #:openai-uri openai-uri
                                    #:api-key api-key
                                    #:temperature temperature))

  (match resp
    [(hash* ['choices
             (cons (hash* ['message (hash* ['content content])])
                   _)])
     content]
    [_ #f]))