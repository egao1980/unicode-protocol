(in-package #:unicode-protocol)

(defconstant +max-code-point+ #x10FFFF)

(defun code-point-p (x)
  "True when X is a Unicode scalar value (0..10FFFF, not a surrogate)."
  (and (integerp x)
       (<= 0 x +max-code-point+)
       (not (<= #xD800 x #xDFFF))))

(deftype code-point ()
  '(satisfies code-point-p))

(defun %utf16-pair-code-point (hi lo)
  (+ #x10000 (ash (- hi #xD800) 10) (- lo #xDC00)))

(defun string-code-point (string &optional (start 0))
  "First Unicode scalar value in STRING at START (handles UTF-16 surrogate pairs)."
  (let* ((s (string string))
         (n (length s)))
    (unless (< start n)
      (error 'unicode-invalid-code-point
             :code-point nil
             :message (format nil "empty string / start ~s out of range for ~s" start s)))
    (let ((c0 (char-code (char s start))))
      (if (and (<= #xD800 c0 #xDBFF) (< (1+ start) n))
          (let ((c1 (char-code (char s (1+ start)))))
            (if (<= #xDC00 c1 #xDFFF)
                (%utf16-pair-code-point c0 c1)
                c0))
          c0))))

(defun code-point-string (code-point)
  "STRING containing the UTF-16 encoding of CODE-POINT (portable across ABCL)."
  (let ((cp (ensure-code-point code-point)))
    (if (<= cp #xFFFF)
        (string (code-char cp))
        (let* ((v (- cp #x10000))
               (hi (+ #xD800 (ash v -10)))
               (lo (+ #xDC00 (logand v #x3FF))))
          (map 'string #'code-char (list hi lo))))))

(defun ensure-code-point (x)
  "Coerce character, integer, or string to a Unicode scalar value.
On ABCL, CHARACTER is a UTF-16 code unit — astral planes via (code-char #x1F600)
silently truncate. Prefer integers, or a STRING (surrogate pair) / CODE-POINT-STRING."
  (let ((cp (etypecase x
              (character (char-code x))
              (integer x)
              (string (string-code-point x)))))
    (unless (code-point-p cp)
      (error 'unicode-invalid-code-point
             :code-point cp
             :message (format nil "not a Unicode scalar value: ~s" x)))
    cp))
