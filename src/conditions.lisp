(in-package #:unicode-protocol)

(define-condition unicode-error (error)
  ((message :initarg :message :reader unicode-error-message :initform nil)
   (code-point :initarg :code-point :reader unicode-error-code-point :initform nil)
   (capability :initarg :capability :reader unicode-error-capability :initform nil))
  (:report (lambda (c s)
             (format s "unicode error~@[: ~a~]" (unicode-error-message c)))))

(define-condition unicode-unsupported (unicode-error) ()
  (:report (lambda (c s)
             (format s "unicode capability unsupported~@[: ~a~]~@[ (~s)~]"
                     (unicode-error-message c)
                     (unicode-error-capability c)))))

(define-condition unicode-invalid-code-point (unicode-error) ()
  (:report (lambda (c s)
             (format s "invalid Unicode code point~@[ ~s~]~@[: ~a~]"
                     (unicode-error-code-point c)
                     (unicode-error-message c)))))

(define-condition unicode-idna-error (unicode-error) ()
  (:report (lambda (c s)
             (format s "IDNA error~@[: ~a~]" (unicode-error-message c)))))
