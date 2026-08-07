(in-package #:unicode-protocol)

;;; Locale-independent case mapping (ICU simple + default full case).
;;; Locale-/language-sensitive case → l10n-protocol.

(defgeneric backend-casefold (backend string &key)
  (:documentation "Full Unicode case fold of STRING."))

(defgeneric backend-downcase (backend string &key)
  (:documentation "Full lowercase mapping (root/default)."))

(defgeneric backend-upcase (backend string &key)
  (:documentation "Full uppercase mapping (root/default)."))

(defgeneric backend-titlecase (backend string &key)
  (:documentation "Full titlecase mapping (root/default)."))

(defgeneric backend-simple-casefold (backend code-point)
  (:documentation "Simple case fold → code point."))

(defgeneric backend-simple-downcase (backend code-point)
  (:documentation "Simple lowercase → code point."))

(defgeneric backend-simple-upcase (backend code-point)
  (:documentation "Simple uppercase → code point."))

(defgeneric backend-simple-titlecase (backend code-point)
  (:documentation "Simple titlecase → code point."))

(defun casefold (string &key (backend *unicode-backend*))
  (backend-casefold
   (require-capability :casefold (ensure-unicode-backend backend))
   (string string)))

(defun downcase (string &key (backend *unicode-backend*))
  (backend-downcase
   (require-capability :casefold (ensure-unicode-backend backend))
   (string string)))

(defun upcase (string &key (backend *unicode-backend*))
  (backend-upcase
   (require-capability :casefold (ensure-unicode-backend backend))
   (string string)))

(defun titlecase (string &key (backend *unicode-backend*))
  (backend-titlecase
   (require-capability :casefold (ensure-unicode-backend backend))
   (string string)))

(defun simple-casefold (object &key (backend *unicode-backend*))
  (backend-simple-casefold
   (require-capability :casefold (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun simple-downcase (object &key (backend *unicode-backend*))
  (backend-simple-downcase
   (require-capability :casefold (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun simple-upcase (object &key (backend *unicode-backend*))
  (backend-simple-upcase
   (require-capability :casefold (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun simple-titlecase (object &key (backend *unicode-backend*))
  (backend-simple-titlecase
   (require-capability :casefold (ensure-unicode-backend backend))
   (ensure-code-point object)))
