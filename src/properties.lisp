(in-package #:unicode-protocol)

;;; ICU uchar.h / UCharacter — property keywords ≈ PropertyAliases long names.

(defgeneric backend-binary-property-p (backend code-point property)
  (:documentation "True when CODE-POINT has binary PROPERTY keyword (e.g. :alphabetic)."))

(defgeneric backend-int-property (backend code-point property)
  (:documentation "Enumerated/integer PROPERTY value as keyword or integer (e.g. :script → :latin)."))

(defgeneric backend-char-name (backend code-point &key choice)
  (:documentation "Unicode name string, or NIL. CHOICE :unicode (default) | :alias | :extended."))

(defgeneric backend-lookup-name (backend name)
  (:documentation "Code point for NAME, or NIL."))

(defgeneric backend-numeric-value (backend code-point)
  (:documentation "Numeric value as rational/float, or NIL."))

(defgeneric backend-digit-value (backend code-point &key radix)
  (:documentation "Digit value in RADIX (default 10), or NIL."))

(defgeneric backend-mirror-char (backend code-point)
  (:documentation "Bidi mirroring glyph code point, or CODE-POINT itself."))

(defgeneric backend-age (backend code-point)
  (:documentation "Unicode version when assigned, e.g. (1 1 0 0), or NIL."))

(defun binary-property-p (object property &key (backend *unicode-backend*))
  "ICU hasBinaryProperty. PROPERTY is a keyword (:alphabetic, :white-space, :emoji, …)."
  (backend-binary-property-p
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object) property))

(defun int-property (object property &key (backend *unicode-backend*))
  "ICU getIntPropertyValue. Returns keyword or integer depending on PROPERTY."
  (backend-int-property
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object) property))

(defun general-category (object &key (backend *unicode-backend*))
  "General_Category as keyword (:lu :ll :nd :zs …)."
  (int-property object :general-category :backend backend))

(defun bidi-class (object &key (backend *unicode-backend*))
  (int-property object :bidi-class :backend backend))

(defun combining-class (object &key (backend *unicode-backend*))
  (int-property object :canonical-combining-class :backend backend))

(defun unicode-block (object &key (backend *unicode-backend*))
  "Unicode Block property (ICU UCHAR_BLOCK). Named UNICODE-BLOCK to avoid CL:BLOCK."
  (int-property object :block :backend backend))

(defun script (object &key (backend *unicode-backend*))
  (require-capability :script (ensure-unicode-backend backend))
  (int-property object :script :backend backend))

(defgeneric backend-script-extensions (backend code-point)
  (:documentation "List of script keywords (Script_Extensions)."))

(defun script-extensions (object &key (backend *unicode-backend*))
  (backend-script-extensions
   (require-capability :script (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun east-asian-width (object &key (backend *unicode-backend*))
  (int-property object :east-asian-width :backend backend))

(defun unicode-name (object &key (choice :unicode) (backend *unicode-backend*))
  "Unicode character name (ICU u_charName). Named UNICODE-NAME to avoid CL:CHAR-NAME."
  (backend-char-name
   (require-capability :char-name (ensure-unicode-backend backend))
   (ensure-code-point object) :choice choice))

(defun unicode-name-alias (object &key (backend *unicode-backend*))
  (unicode-name object :choice :alias :backend backend))

(defun lookup-name (name &key (backend *unicode-backend*))
  (backend-lookup-name
   (require-capability :char-name (ensure-unicode-backend backend))
   name))

(defun numeric-value (object &key (backend *unicode-backend*))
  (backend-numeric-value
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun digit-value (object &key (radix 10) (backend *unicode-backend*))
  (backend-digit-value
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object) :radix radix))

(defun mirrored-p (object &key (backend *unicode-backend*))
  (binary-property-p object :bidi-mirrored :backend backend))

(defun mirror-char (object &key (backend *unicode-backend*))
  (backend-mirror-char
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defun age (object &key (backend *unicode-backend*))
  (backend-age
   (require-capability :properties (ensure-unicode-backend backend))
   (ensure-code-point object)))

(defgeneric backend-property-value-name (backend property value &key short)
  (:documentation "String name for PROPERTY value (PropertyValueAliases)."))

(defun property-value-name (property value &key short (backend *unicode-backend*))
  (backend-property-value-name
   (require-capability :properties (ensure-unicode-backend backend))
   property value :short short))

;;; Predicates — ICU u_isUAlphabetic-style sugar over binary/int properties.

(defun alphabetic-p (object &key (backend *unicode-backend*))
  (binary-property-p object :alphabetic :backend backend))

(defun lowercase-p (object &key (backend *unicode-backend*))
  (binary-property-p object :lowercase :backend backend))

(defun uppercase-p (object &key (backend *unicode-backend*))
  (binary-property-p object :uppercase :backend backend))

(defun titlecase-p (object &key (backend *unicode-backend*))
  (eq (general-category object :backend backend) :lt))

(defun digit-p (object &key (backend *unicode-backend*))
  (eq (general-category object :backend backend) :nd))

(defun hex-digit-p (object &key (backend *unicode-backend*))
  (binary-property-p object :hex-digit :backend backend))

(defun whitespace-p (object &key (backend *unicode-backend*))
  (binary-property-p object :white-space :backend backend))

(defun blank-p (object &key (backend *unicode-backend*))
  (binary-property-p object :posix-blank :backend backend))

(defun defined-p (object &key (backend *unicode-backend*))
  (not (eq (general-category object :backend backend) :cn)))

(defun letter-p (object &key (backend *unicode-backend*))
  (let ((gc (general-category object :backend backend)))
    (member gc '(:lu :ll :lt :lm :lo) :test #'eq)))

(defun letter-or-digit-p (object &key (backend *unicode-backend*))
  (or (letter-p object :backend backend)
      (digit-p object :backend backend)))

(defun ideographic-p (object &key (backend *unicode-backend*))
  (binary-property-p object :ideographic :backend backend))

(defun emoji-p (object &key (backend *unicode-backend*))
  (require-capability :emoji (ensure-unicode-backend backend))
  (binary-property-p object :emoji :backend backend))

(defun emoji-presentation-p (object &key (backend *unicode-backend*))
  (require-capability :emoji (ensure-unicode-backend backend))
  (binary-property-p object :emoji-presentation :backend backend))

(defun extended-pictographic-p (object &key (backend *unicode-backend*))
  (require-capability :emoji (ensure-unicode-backend backend))
  (binary-property-p object :extended-pictographic :backend backend))

(defun identifier-start-p (object &key (backend *unicode-backend*))
  (binary-property-p object :id-start :backend backend))

(defun identifier-part-p (object &key (backend *unicode-backend*))
  (binary-property-p object :id-continue :backend backend))

(defun xid-start-p (object &key (backend *unicode-backend*))
  (binary-property-p object :xid-start :backend backend))

(defun xid-part-p (object &key (backend *unicode-backend*))
  (binary-property-p object :xid-continue :backend backend))
