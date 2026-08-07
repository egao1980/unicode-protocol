(in-package #:unicode-protocol)

;;; ICU UnicodeSet — pattern syntax [:Letter:] / \p{…} kept as strings;
;;; Lisp API is set ops + span.

(defclass unicode-set ()
  ((raw :initarg :raw :accessor uset-raw :initform nil)
   (pattern :initarg :pattern :reader uset-pattern :initform nil))
  (:documentation "Set of Unicode code points / strings (ICU UnicodeSet)."))

(defgeneric backend-make-unicode-set (backend &key pattern freeze)
  (:documentation "Empty set, or parse PATTERN (ICU pattern syntax)."))

(defgeneric backend-uset-contains-p (backend set object)
  (:documentation "OBJECT is code-point or string."))

(defgeneric backend-uset-span (backend set string &key start end contained)
  (:documentation "→ end index of span. CONTAINED T = span while in set."))

(defgeneric backend-uset-span-back (backend set string &key start end contained))

(defgeneric backend-uset-size (backend set))
(defgeneric backend-uset-empty-p (backend set))
(defgeneric backend-uset-complement (backend set))
(defgeneric backend-uset-add (backend set object))
(defgeneric backend-uset-remove (backend set object))
(defgeneric backend-uset-retain (backend set other))
(defgeneric backend-uset-clear (backend set))

(defun make-unicode-set (&key pattern freeze (backend *unicode-backend*))
  (backend-make-unicode-set
   (require-capability :uset (ensure-unicode-backend backend))
   :pattern pattern :freeze freeze))

(defun uset-contains-p (set object &key (backend *unicode-backend*))
  (backend-uset-contains-p (ensure-unicode-backend backend) set
                           (if (or (characterp object) (integerp object))
                               (ensure-code-point object)
                               object)))

(defun uset-span (set string &key (start 0) end (contained t) (backend *unicode-backend*))
  (backend-uset-span (ensure-unicode-backend backend) set (string string)
                     :start start :end end :contained contained))

(defun uset-span-back (set string &key start end (contained t) (backend *unicode-backend*))
  (backend-uset-span-back (ensure-unicode-backend backend) set (string string)
                          :start start :end end :contained contained))

(defun uset-size (set &key (backend *unicode-backend*))
  (backend-uset-size (ensure-unicode-backend backend) set))

(defun uset-empty-p (set &key (backend *unicode-backend*))
  (backend-uset-empty-p (ensure-unicode-backend backend) set))

(defun uset-complement (set &key (backend *unicode-backend*))
  (backend-uset-complement (ensure-unicode-backend backend) set)
  set)

(defun uset-add (set object &key (backend *unicode-backend*))
  (backend-uset-add (ensure-unicode-backend backend) set
                    (if (or (characterp object) (integerp object))
                        (ensure-code-point object)
                        object))
  set)

(defun uset-remove (set object &key (backend *unicode-backend*))
  (backend-uset-remove (ensure-unicode-backend backend) set
                       (if (or (characterp object) (integerp object))
                           (ensure-code-point object)
                           object))
  set)

(defun uset-retain (set other &key (backend *unicode-backend*))
  (backend-uset-retain (ensure-unicode-backend backend) set other)
  set)

(defun uset-clear (set &key (backend *unicode-backend*))
  (backend-uset-clear (ensure-unicode-backend backend) set)
  set)
