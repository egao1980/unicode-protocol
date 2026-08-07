(in-package #:unicode-protocol)

;;; ICU BreakIterator — grapheme / word / line / sentence.

(defclass break-iterator ()
  ((kind :initarg :kind :reader break-kind
         :documentation "One of :grapheme :word :line :sentence.")
   (raw :initarg :raw :accessor break-raw :initform nil
        :documentation "Backend-private state."))
  (:documentation "Text boundary iterator (UAX #29 / ICU BreakIterator)."))

(defgeneric backend-make-break-iterator (backend kind &key locale)
  (:documentation "→ break-iterator. LOCALE reserved; locale-sensitive word/line may need l10n data."))

(defgeneric backend-break-set-text (backend iterator text)
  (:documentation "Bind TEXT into ITERATOR."))

(defgeneric backend-break-first (backend iterator))
(defgeneric backend-break-last (backend iterator))
(defgeneric backend-break-next (backend iterator))
(defgeneric backend-break-previous (backend iterator))
(defgeneric backend-break-current (backend iterator))
(defgeneric backend-break-following (backend iterator offset))
(defgeneric backend-break-preceding (backend iterator offset))
(defgeneric backend-break-is-boundary-p (backend iterator offset))

(defun make-break-iterator (kind &key locale (backend *unicode-backend*))
  "KIND ∈ (:grapheme :word :line :sentence). :grapheme = extended grapheme clusters."
  (check-type kind (member :grapheme :word :line :sentence))
  (backend-make-break-iterator
   (require-capability :breaks (ensure-unicode-backend backend))
   kind :locale locale))

(defun break-set-text (iterator text &key (backend *unicode-backend*))
  (backend-break-set-text (ensure-unicode-backend backend) iterator (string text))
  iterator)

(defun break-first (iterator &key (backend *unicode-backend*))
  (backend-break-first (ensure-unicode-backend backend) iterator))

(defun break-last (iterator &key (backend *unicode-backend*))
  (backend-break-last (ensure-unicode-backend backend) iterator))

(defun break-next (iterator &key (backend *unicode-backend*))
  (backend-break-next (ensure-unicode-backend backend) iterator))

(defun break-previous (iterator &key (backend *unicode-backend*))
  (backend-break-previous (ensure-unicode-backend backend) iterator))

(defun break-current (iterator &key (backend *unicode-backend*))
  (backend-break-current (ensure-unicode-backend backend) iterator))

(defun break-following (iterator offset &key (backend *unicode-backend*))
  (backend-break-following (ensure-unicode-backend backend) iterator offset))

(defun break-preceding (iterator offset &key (backend *unicode-backend*))
  (backend-break-preceding (ensure-unicode-backend backend) iterator offset))

(defun break-is-boundary-p (iterator offset &key (backend *unicode-backend*))
  (backend-break-is-boundary-p (ensure-unicode-backend backend) iterator offset))

(defun map-breaks (function text &key (kind :grapheme) locale (backend *unicode-backend*))
  "Call FUNCTION with (start end) for each break unit in TEXT. Returns NIL."
  (let* ((b (ensure-unicode-backend backend))
         (it (make-break-iterator kind :locale locale :backend b))
         (s (string text)))
    (break-set-text it s :backend b)
    (loop with start = (break-first it :backend b)
          for end = (break-next it :backend b)
          until (or (null end) (eql end -1) (>= end (length s)))
          do (funcall function start end)
             (setf start end)
          finally (when (and start (< start (length s)))
                    (funcall function start (length s))))
    nil))
