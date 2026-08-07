(in-package #:unicode-protocol)

;;; ICU IDNA / UTS #46. Full ToASCII/ToUnicode lives here; cl-idna will rearrange later.
;;; Options as keywords (not bitflags): :std3 :transitional :check-bidi :check-contextj …

(defgeneric backend-idna-name-to-ascii (backend name &key options)
  (:documentation "Domain → ACE (A-labels). OPTIONS = list of keywords."))

(defgeneric backend-idna-name-to-unicode (backend name &key options)
  (:documentation "ACE/domain → Unicode (U-labels)."))

(defgeneric backend-idna-label-to-ascii (backend label &key options)
  (:documentation "Single label → A-label."))

(defgeneric backend-idna-label-to-unicode (backend label &key options)
  (:documentation "Single label → U-label."))

(defgeneric backend-idna-map (backend string &key std3 transitional)
  (:documentation "UTS #46 mapping step only (no Punycode)."))

(defun idna-name-to-ascii (name &key options (backend *unicode-backend*))
  (backend-idna-name-to-ascii
   (require-capability :idna (ensure-unicode-backend backend))
   (string name) :options options))

(defun idna-name-to-unicode (name &key options (backend *unicode-backend*))
  (backend-idna-name-to-unicode
   (require-capability :idna (ensure-unicode-backend backend))
   (string name) :options options))

(defun idna-label-to-ascii (label &key options (backend *unicode-backend*))
  (backend-idna-label-to-ascii
   (require-capability :idna (ensure-unicode-backend backend))
   (string label) :options options))

(defun idna-label-to-unicode (label &key options (backend *unicode-backend*))
  (backend-idna-label-to-unicode
   (require-capability :idna (ensure-unicode-backend backend))
   (string label) :options options))

(defun idna-map (string &key std3 transitional (backend *unicode-backend*))
  "UTS #46 compatibility mapping (ICU/UTS46 preprocess)."
  (backend-idna-map
   (require-capability :idna (ensure-unicode-backend backend))
   (string string) :std3 std3 :transitional transitional))
