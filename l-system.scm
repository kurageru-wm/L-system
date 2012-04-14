;;;
;;; L-system
;;;
;;;
;;; Copyright (C) 2012 kurageruwm <kurageruwm@gmail.com>
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation file
;;; s (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,m 
;;; erge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnis
;;; hed to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
;;; IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;;;

(define-module l-system
  (export <G>
          <V-symbol>
          define-rule
          step
          v-list->list
          v-list->n-list
          convert
          n-of
          )
  )

(select-module l-system)


(define-class <G> ()
  ((rules :init-keyword :rules
          :accessor rules-of
          :init-value '())   
   (l :init-keyword :init
      :accessor get)   
   ))

(define-method initialize ((self <G>) initargs)
  (next-method)
  (set! (get self) (map (cut make <V-symbol> :symbol <>) (get self)))
  (set! (rules-of self) (apply compose (rules-of self)))
  )

;; V-Symbol
(define-class <V-symbol> ()
  ((n :init-keyword :n
      :init-value 0
      :accessor n-of)
   (symbol :init-keyword :symbol
           :init-value #f
           :accessor symbol-of)
   ))


(define-syntax define-rule
  (syntax-rules ()
    ((_ name from to)
     (define (name x cont)
       (if (eq? x from)
           (cont to)
           (values x cont))
       ))))

(define-method step ((g <G>) (n <integer>))
  (define (update! l)
    (map
     (lambda (x)
       (set! (n-of x) (+ (n-of x) 1)) x)
     l))
  
  (define (f x coll)
    (let1 res (call/cc (cut (rules-of g) (symbol-of x) <>))
          (append
           (if (list? res)
               (map (cut make <V-symbol> :symbol <>) res)               
               `(,x))
           coll)
          ))
  
  (let loop ((i 0) (l (get g)))
    (if (= i n)
        l
        (loop (+ i 1)
              (update! (fold-right f '() l))))    
    ))

(define-method v-list->list ((vl <list>))
  (map (cut symbol-of <>) vl)
  )
(define-method v-list->n-list ((vl <list>))
  (map (cut n-of <>) vl))


(define-syntax convert
  (syntax-rules ()
    ((_ before pair ...)
     (convert/hash before
                   (hash-table 'equal? pair ...)))))

(define-method convert/hash (l (ht <hash-table>))  
  (map (lambda (x)
         ((hash-table-get ht (symbol-of x) x)
          x))       
       l))

(provide "l-system")
