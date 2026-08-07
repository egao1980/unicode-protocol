(defpackage #:unicode-protocol
  (:use #:cl)
  (:nicknames #:stack-unicode)
  (:export
   ;; conditions
   #:unicode-error
   #:unicode-unsupported
   #:unicode-invalid-code-point
   #:unicode-idna-error
   #:unicode-error-message
   #:unicode-error-code-point
   #:unicode-error-capability

   ;; backend
   #:unicode-backend
   #:*unicode-backend*
   #:backend-capabilities
   #:use-unicode-backend
   #:with-unicode-backend
   #:ensure-unicode-backend
   #:require-capability

   ;; types / code points
   #:code-point
   #:code-point-p
   #:ensure-code-point
   #:+max-code-point+

   ;; properties (ICU uchar / UCharacter)
   #:binary-property-p
   #:int-property
   #:general-category
   #:bidi-class
   #:combining-class
   #:unicode-block
   #:script
   #:script-extensions
   #:east-asian-width
   #:unicode-name
   #:unicode-name-alias
   #:lookup-name
   #:numeric-value
   #:digit-value
   #:mirrored-p
   #:mirror-char
   #:age
   #:property-value-name

   ;; predicates (ICU sugar)
   #:alphabetic-p
   #:lowercase-p
   #:uppercase-p
   #:titlecase-p
   #:digit-p
   #:hex-digit-p
   #:whitespace-p
   #:blank-p
   #:defined-p
   #:letter-p
   #:letter-or-digit-p
   #:ideographic-p
   #:emoji-p
   #:emoji-presentation-p
   #:extended-pictographic-p
   #:identifier-start-p
   #:identifier-part-p
   #:xid-start-p
   #:xid-part-p

   ;; normalize (ICU Normalizer2)
   #:normalize
   #:normalized-p
   #:quick-check
   #:normalization-boundary-before-p
   #:normalization-boundary-after-p
   #:raw-decomposition

   ;; case (locale-independent; locale-aware → l10n-protocol)
   #:casefold
   #:downcase
   #:upcase
   #:titlecase
   #:simple-casefold
   #:simple-downcase
   #:simple-upcase
   #:simple-titlecase

   ;; IDNA / UTS #46 (ICU IDNA; cl-idna will rearrange onto this)
   #:idna-name-to-ascii
   #:idna-name-to-unicode
   #:idna-label-to-ascii
   #:idna-label-to-unicode
   #:idna-map

   ;; breaks (ICU BreakIterator)
   #:break-iterator
   #:make-break-iterator
   #:break-set-text
   #:break-first
   #:break-last
   #:break-next
   #:break-previous
   #:break-current
   #:break-following
   #:break-preceding
   #:break-is-boundary-p
   #:map-breaks

   ;; UnicodeSet (ICU UnicodeSet)
   #:unicode-set
   #:make-unicode-set
   #:uset-contains-p
   #:uset-span
   #:uset-span-back
   #:uset-size
   #:uset-empty-p
   #:uset-pattern
   #:uset-complement
   #:uset-add
   #:uset-remove
   #:uset-retain
   #:uset-clear))

(in-package #:unicode-protocol)
