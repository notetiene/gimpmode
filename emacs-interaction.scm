;; Stuff needed for interaction with the emacs-modes `gimp-mode' `inferior-gimp-mode'
;; and `gimp-help-mode'.

;; Do not use these functions in your own programs, though anyone is free to copy them
;; using a different namespace.

(define (emacs-describe-function sym)
  (gimp-procedural-db-proc-info (symbol->string sym)))

(define (emacs-describe-function-arg sym arg)
  (let ((output (gimp-procedural-db-proc-arg (symbol->string sym) arg)))
    (set-car! output
              (cdr (assv (car output) emacs-type-to-readable-type-map)))))

(define (emacs-describe-function-args sym)
    (let ((arg (list-ref (emacs-describe-function sym) 6))
          (list ()))
      (do ((vec (make-vector arg))
           (i 0 (+ i 1)))
          ((= i arg) vec)
        (vector-set! vec i (emacs-describe-function-arg sym i)))))

(define emacs-type-to-readable-type-map
  '((0  . "INT32")
    (1  . "INT16")
    (2  . "INT8")
    (3  . "FLOAT")
    (4  . "STRING")
    (5  . "INT32ARRAY")
    (6  . "INT16ARRAY")
    (7  . "INT8ARRAY")
    (8  . "FLOATARRAY")
    (9  . "STRINGARRAY")
    (10 . "COLOR")
    (11 . "REGION")
    (12 . "DISPLAY")
    (13 . "IMAGE")
    (14 . "LAYER")
    (15 . "CHANNEL")
    (16 . "DRAWABLE")
    (17 . "SELECTION")
    (18 . "BOUNDARY")
    (19 . "PATH")
    (20 . "STATUS")))

(define (emacs-describe-function-string sym)
    (let ((arg (list-ref (emacs-describe-function sym) 6)))
      (do ((str (symbol->string sym))
           (i 0 (+ i 1)))
          ((= i arg) (string-append "(" str ")"))
        (let ((desc (emacs-describe-function-arg sym i)))
          (set! str (string-append str " (" (cadr desc)
                                          " "
                                          (car desc)
                                           ")"))))))

(define (emacs-pdb-doc sym)
  (let ((arg (list-ref (emacs-describe-function sym) 6))
        (lst (list sym)))
    (do ((i 0 (+ i 1)))
        ((= i arg) lst)
      (let ((argument (emacs-describe-function-arg sym i)))
        (set! lst (append lst (list
                               (map string->atom
                                    (list (cadr argument)
                                           (car argument))))))))))

                                                                                               
(define (emacs-funstring sym)
  (emacs-describe-function-args sym))

(define (emacs-flatten l)
  (cond ((null? l) ())
        ((list? l)
         (append (emacs-flatten (car l)) (emacs-flatten (cdr l))))
        (else (list l))))

(define (emacs-short-description name)
 (let ((info (gimp-procedural-db-proc-info name)))
   (string-append (car info)
                  "\n\n"
                  (cadr info) "\n\nAuthor(s): " (list-ref info 2)
                  "\nCopyright: " (list-ref info 3) ", " (list-ref info 4))))


(define (emacs-type-of-arg name position)
  (let* ((name (if (symbol? name)
                   (symbol->string name)
                   name))
         (elems (gimp-procedural-db-proc-arg name position)))
    (case (car elems)
      ((4) (if (or (string=? (cadr elems) "filename")
                 (string=? (cadr elems) "raw-filename"))
             'file
             'other-string))
      (else 'other))))

;; (define (delete elem lst)
;;    lst (when (pair? lst)
;;          (append (if (eqv? elem (car lst))
;;                    ()
;;                    (list (car lst)))
;;                  (delete elem (cdr lst)))))



