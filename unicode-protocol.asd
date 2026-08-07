(defsystem "unicode-protocol"
  :version "0.1.0"
  :description "CLOS Unicode protocol for cl-stack (ICU-shaped: properties, normalize, case, IDNA, breaks, UnicodeSet)"
  :author "egao1980"
  :license "MIT"
  :depends-on ()
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "conditions")
               (:file "types")
               (:file "backend")
               (:file "properties")
               (:file "normalize")
               (:file "case")
               (:file "idna")
               (:file "break")
               (:file "uset"))
  :in-order-to ((test-op (test-op "unicode-protocol/tests"))))

(defsystem "unicode-protocol/tests"
  :depends-on ("unicode-protocol" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "protocol-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
