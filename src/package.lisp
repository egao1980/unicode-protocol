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

   ;; backend GFs (for backend implementors)
   #:backend-binary-property-p
   #:backend-int-property
   #:backend-char-name
   #:backend-lookup-name
   #:backend-numeric-value
   #:backend-digit-value
   #:backend-mirror-char
   #:backend-age
   #:backend-script-extensions
   #:backend-property-value-name
   #:backend-normalize
   #:backend-normalized-p
   #:backend-quick-check
   #:backend-normalization-boundary-before-p
   #:backend-normalization-boundary-after-p
   #:backend-raw-decomposition
   #:backend-casefold
   #:backend-downcase
   #:backend-upcase
   #:backend-titlecase
   #:backend-simple-casefold
   #:backend-simple-downcase
   #:backend-simple-upcase
   #:backend-simple-titlecase
   #:backend-idna-name-to-ascii
   #:backend-idna-name-to-unicode
   #:backend-idna-label-to-ascii
   #:backend-idna-label-to-unicode
   #:backend-idna-map
   #:backend-make-break-iterator
   #:backend-break-set-text
   #:backend-break-first
   #:backend-break-last
   #:backend-break-next
   #:backend-break-previous
   #:backend-break-current
   #:backend-break-following
   #:backend-break-preceding
   #:backend-break-is-boundary-p
   #:backend-make-unicode-set
   #:backend-uset-contains-p
   #:backend-uset-span
   #:backend-uset-span-back
   #:backend-uset-size
   #:backend-uset-empty-p
   #:backend-uset-complement
   #:backend-uset-add
   #:backend-uset-remove
   #:backend-uset-retain
   #:backend-uset-clear

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
   #:break-kind
   #:break-raw
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
   #:uset-raw
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
