(in-package #:unicode-protocol)

(defconstant +max-code-point+ #x10FFFF)

(defun code-point-p (x)
  "True when X is a Unicode scalar value (0..10FFFF, not a surrogate)."
  (and (integerp x)
       (<= 0 x +max-code-point+)
       (not (<= #xD800 x #xDFFF))))

(deftype code-point ()
  '(satisfies code-point-p))

(defun ensure-code-point (x)
  "Coerce character or integer to a code-point integer. Signals UNICODE-INVALID-CODE-POINT."
  (let ((cp (etypecase x
              (character (char-code x))
              (integer x))))
    (unless (code-point-p cp)
      (error 'unicode-invalid-code-point
             :code-point cp
             :message (format nil "not a Unicode scalar value: ~s" x)))
    cp))
