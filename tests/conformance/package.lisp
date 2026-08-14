(in-package #:cl-user)

(defpackage #:unicode-protocol/conformance
  (:use #:cl #:rove #:unicode-protocol)
  (:export #:*test-backend-maker*
           #:with-test-backend
           #:capability-or-skip))

(in-package #:unicode-protocol/conformance)

(defvar *test-backend-maker* nil
  "Thunk → UNICODE-BACKEND for the current conformance run.
If NIL, uses the already-installed *UNICODE-BACKEND*.")

(defmacro with-test-backend ((backend) &body body)
  "Bind BACKEND from *TEST-BACKEND-MAKER* (or *UNICODE-BACKEND*) and run BODY under WITH-UNICODE-BACKEND."
  (let ((b (gensym "BACKEND")))
    `(let* ((,b (if *test-backend-maker*
                    (funcall *test-backend-maker*)
                    (or *unicode-backend*
                        (error "No unicode backend: set *test-backend-maker* or *unicode-backend*"))))
            (,backend ,b))
       (with-unicode-backend ,b
         ,@body))))

(defmacro capability-or-skip (cap &body body)
  "Run BODY when BACKEND has CAP; otherwise skip (rove skip)."
  `(with-test-backend (backend)
     (if (member ,cap (backend-capabilities backend) :test #'eq)
         (progn ,@body)
         (skip (format nil "backend lacks ~s" ,cap)))))
