;; Sierpinski triangle

(use l-system)

(define-rule a->x 'a '(b - a - b))
(define-rule b->x 'b '(a + b + a))

(define si (make <G> :init '(a) :rules `(,a->x ,b->x)))

(define (main args)
  (print (v-list->list (step si 2)))
  (print (v-list->n-list (step si 2)))
  )
