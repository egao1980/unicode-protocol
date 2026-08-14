;;; Shared unicode-protocol conformance suite (backend-agnostic).
;;;
;;; Backends:
;;;   (setf unicode-protocol/conformance:*test-backend-maker*
;;;         (lambda () (make-instance '…)))
;;;   (rove:run (asdf:find-system "unicode-protocol/conformance"))
;;;
;;; Or install a backend that binds *unicode-backend* and run with
;;; *test-backend-maker* left NIL.
