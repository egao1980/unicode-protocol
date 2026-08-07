(in-package #:unicode-protocol)

;;; Backend swap — same shape as json-protocol / crypto-protocol.
;;; Capabilities mirror ICU modules backends may only partially implement.

(defclass unicode-backend () ()
  (:documentation "Base class for unicode-protocol backends (cl-unicode, sb-unicode, ICU4C, …)."))

(defvar *unicode-backend* nil
  "Current unicode backend. Set by loading unicode-backend-* or USE-UNICODE-BACKEND.")

(defgeneric backend-capabilities (backend)
  (:documentation "List of capability keywords this backend implements.
Known keywords:
  :properties :normalize :casefold :idna :breaks :uset
  :nfkc-casefold :script :emoji :char-name
Partial backends (e.g. sb-unicode) omit :idna.")
  (:method ((backend unicode-backend)) '()))

(defun use-unicode-backend (backend)
  "Install BACKEND as *UNICODE-BACKEND*. Returns BACKEND."
  (check-type backend unicode-backend)
  (setf *unicode-backend* backend))

(defmacro with-unicode-backend (backend &body body)
  `(let ((*unicode-backend* ,backend))
     ,@body))

(defun ensure-unicode-backend (&optional (backend *unicode-backend*))
  (or backend
      (error 'unicode-error
             :message "*unicode-backend* is nil — load a unicode-backend-* system")))

(defun require-capability (capability &optional (backend (ensure-unicode-backend)))
  "Signal UNICODE-UNSUPPORTED when BACKEND lacks CAPABILITY. Returns BACKEND."
  (unless (member capability (backend-capabilities backend) :test #'eq)
    (error 'unicode-unsupported
           :capability capability
           :message (format nil "backend ~a lacks ~s" backend capability)))
  backend)
