#lang racket

; Define the total heap size and the size of each semi-space
(define heap-size 16)
(define semispace-size (/ heap-size 2))

; Define a cell structure with two values
(struct cell (val1 val2))

; Create two semi-spaces (from-space and to-space) for the garbage collector
; Initialize both semi-spaces with default cells containing (0, 0)
(define from-space (make-vector semispace-size (cell 0 0)))
(define to-space (make-vector semispace-size (cell 0 0)))

; Define free-pointer for tracking the next available memory location in from-space
; Define scan-pointer for tracking the position in to-space during garbage collection
(define free-pointer 0)
(define scan-pointer 0)

; Function to reset both free-pointer and scan-pointer to 0
(define (reset-pointers)
  (set! free-pointer 0)
  (set! scan-pointer 0))

; Function to allocate a new cell in the from-space
(define (alloc-cell val1 val2)
  ; If there is no more space available, trigger garbage collection
  (when (>= free-pointer semispace-size)
    (collect-garbage))
  ; Create a new cell with the given values and store it in from-space
  (define new-cell (cell val1 val2))
  (vector-set! from-space free-pointer new-cell)
  ; Increment the free-pointer
  (set! free-pointer (+ free-pointer 1))
  new-cell)

; Function to check if a cell is live, given a root set
(define (is-live? c root-set)
  (ormap (lambda (root) (eq? c root)) root-set))

; Function to perform garbage collection
(define (collect-garbage root-set)
  (reset-pointers)  ; Reset pointers
  ; Iterate through the from-space
  (for ([i (in-range semispace-size)])
    (define current (vector-ref from-space i))
    ; If the current cell is live, copy it to the to-space
    (when (and (cell? current) (is-live? current root-set))
      (define new-cell (copy-cell current))
      (vector-set! from-space i new-cell)))
  ; Swap the semi-spaces after garbage collection
  (swap-semispaces))

; Function to swap the from-space and to-space
(define (swap-semispaces)
  (define temp from-space)
  (set! from-space to-space)
  (set! to-space temp))

; Function to copy a cell from the from-space to the to-space
(define (copy-cell c)
  (define new-cell (cell (cell-val1 c) (cell-val2 c)))
  (vector-set! to-space scan-pointer new-cell)
  (set! scan-pointer (+ scan-pointer 1))
  new-cell)
 
; -----------------------------------------------------------------------------------------------

; Example function to demonstrate the garbage collector
(define (example)
  ; Reset pointers and allocate three cells
  (reset-pointers)
  (define a (alloc-cell 1 2))
  (define b (alloc-cell 3 4))
  (define c (alloc-cell 5 6))
  
  ; Display the contents of the first three cells in from-space before garbage collection
  (displayln "Before garbage collection:")
  (displayln (cons (cell-val1 (vector-ref from-space 0)) (cell-val2 (vector-ref from-space 0))))
  (displayln (cons (cell-val1 (vector-ref from-space 1)) (cell-val2 (vector-ref from-space 1))))
  (displayln (cons (cell-val1 (vector-ref from-space 2)) (cell-val2 (vector-ref from-space 2))))
  (newline)
  
  (set! a #f) ; remove reference to cell a 
  
  ; Perform garbage collection with the new root set (b and c)
  (collect-garbage (list b c))
  
  ; Display the contents of the first three cells in from-space after garbage collection
  (displayln "After garbage collection:")
  (displayln (cons (cell-val1 (vector-ref from-space 0)) (cell-val2 (vector-ref from-space 0))))
  (displayln (cons (cell-val1 (vector-ref from-space 1)) (cell-val2 (vector-ref from-space 1))))
  (displayln (cons (cell-val1 (vector-ref from-space 2)) (cell-val2 (vector-ref from-space 2)))))


#| In the example function, three cells are allocated, and their contents are displayed.
Then, the reference to the first cell (a) is removed, and garbage collection is performed.
After the garbage collection, only the live cells (b and c) are present in the from-space,
and the deallocated cell has its default values (0, 0). |#

(example) 
