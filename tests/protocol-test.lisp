(in-package #:unicode-protocol/tests)

(deftest code-point-coercion
  (ok (= (ensure-code-point #\A) 65))
  (ok (= (ensure-code-point 65) 65))
  (ok (= (ensure-code-point "A") 65))
  (ok (= (string-code-point (code-point-string #x1F600)) #x1F600))
  (ok (signals (ensure-code-point #xD800) 'unicode-invalid-code-point))
  (ok (signals (ensure-code-point #x110000) 'unicode-invalid-code-point)))

(deftest no-backend-signals
  (let ((*unicode-backend* nil))
    (ok (signals (normalize "café") 'unicode-error))
    (ok (signals (general-category #\A) 'unicode-error))
    (ok (signals (idna-name-to-ascii "bücher.de") 'unicode-error))))

(deftest unsupported-capability
  (let* ((b (make-instance 'unicode-backend))
         (*unicode-backend* b))
    (ok (null (backend-capabilities b)))
    (ok (signals (require-capability :normalize b) 'unicode-unsupported))))

(deftest normalize-form-validation
  (let ((*unicode-backend* (make-instance 'unicode-backend)))
    ;; fails on capability before form if we require first — form check runs inside after capability
    (ok (signals (normalize "x" :form :bogus) 'unicode-error))))
