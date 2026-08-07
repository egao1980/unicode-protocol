(in-package #:unicode-protocol)

;;; ICU Normalizer2 — forms as keywords; :nfkc-casefold is an ICU extension.

(defgeneric backend-normalize (backend string form)
  (:documentation "Normalize STRING to FORM (:nfc :nfd :nfkc :nfkd :nfkc-casefold)."))

(defgeneric backend-normalized-p (backend string form)
  (:documentation "True when STRING is already in FORM."))

(defgeneric backend-quick-check (backend string form)
  (:documentation "→ :yes | :no | :maybe (ICU UNormalizationCheckResult)."))

(defgeneric backend-normalization-boundary-before-p (backend code-point form)
  (:documentation "ICU hasBoundaryBefore."))

(defgeneric backend-normalization-boundary-after-p (backend code-point form)
  (:documentation "ICU hasBoundaryAfter."))

(defgeneric backend-raw-decomposition (backend code-point form)
  (:documentation "Raw decomposition mapping string, or NIL."))

(defun %normalize-form (form)
  (check-type form keyword)
  (unless (member form '(:nfc :nfd :nfkc :nfkd :nfkc-casefold) :test #'eq)
    (error 'unicode-error
           :message (format nil "unknown normalization form ~s" form)))
  form)

(defun normalize (string &key (form :nfc) (backend *unicode-backend*))
  "ICU Normalizer2.normalize. FORM default :nfc (W3C exchange default)."
  (let* ((form (%normalize-form form))
         (cap (if (eq form :nfkc-casefold) :nfkc-casefold :normalize))
         (b (require-capability cap (ensure-unicode-backend backend))))
    (backend-normalize b (string string) form)))

(defun normalized-p (string &key (form :nfc) (backend *unicode-backend*))
  (let* ((form (%normalize-form form))
         (cap (if (eq form :nfkc-casefold) :nfkc-casefold :normalize))
         (b (require-capability cap (ensure-unicode-backend backend))))
    (backend-normalized-p b (string string) form)))

(defun quick-check (string &key (form :nfc) (backend *unicode-backend*))
  (let* ((form (%normalize-form form))
         (cap (if (eq form :nfkc-casefold) :nfkc-casefold :normalize))
         (b (require-capability cap (ensure-unicode-backend backend))))
    (backend-quick-check b (string string) form)))

(defun normalization-boundary-before-p (object &key (form :nfc) (backend *unicode-backend*))
  (backend-normalization-boundary-before-p
   (require-capability :normalize (ensure-unicode-backend backend))
   (ensure-code-point object) (%normalize-form form)))

(defun normalization-boundary-after-p (object &key (form :nfc) (backend *unicode-backend*))
  (backend-normalization-boundary-after-p
   (require-capability :normalize (ensure-unicode-backend backend))
   (ensure-code-point object) (%normalize-form form)))

(defun raw-decomposition (object &key (form :nfd) (backend *unicode-backend*))
  (backend-raw-decomposition
   (require-capability :normalize (ensure-unicode-backend backend))
   (ensure-code-point object) (%normalize-form form)))
