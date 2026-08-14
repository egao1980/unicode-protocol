(in-package #:unicode-protocol/conformance)

;;; Shared smoke — backends set *TEST-BACKEND-MAKER* then
;;; (rove:run (asdf:find-system "unicode-protocol/conformance")).

(defun %s (&rest cps)
  (map 'string #'code-char cps))

(deftest capabilities-nonempty
  (with-test-backend (backend)
    (ok (consp (backend-capabilities backend)))
    (ok (every #'keywordp (backend-capabilities backend)))))

(deftest properties-ascii
  (capability-or-skip :properties
    (ok (eq (general-category #\A) :lu))
    (ok (eq (general-category #\a) :ll))
    (ok (eq (general-category #\1) :nd))
    (ok (alphabetic-p #\A))
    (ok (not (alphabetic-p #\1)))
    (ok (uppercase-p #\A))
    (ok (lowercase-p #\a))
    (ok (whitespace-p #\Space))
    (ok (= (numeric-value #\5) 5))))

(deftest script-latin
  (capability-or-skip :script
    (ok (eq (script #\A) :latin))))

(deftest char-name-latin-a
  (capability-or-skip :char-name
    (ok (search "LATIN CAPITAL LETTER A" (unicode-name #\A)))
    (ok (= (lookup-name "LATIN CAPITAL LETTER A") #x0041))))

(deftest normalize-nfc-nfd
  (capability-or-skip :normalize
    (let* ((decomp (%s #x65 #x301))
           (comp (string (code-char #x00E9))))
      (ok (string= (normalize decomp :form :nfc) comp))
      (ok (string= (normalize comp :form :nfd) decomp))
      (ok (normalized-p comp :form :nfc)))))

(deftest normalize-nfkc-ligature
  (capability-or-skip :normalize
    (ok (string= (normalize (string (code-char #xFB01)) :form :nfkc) "fi"))))

(deftest casefold-strasse
  (capability-or-skip :casefold
    (ok (string= (casefold "ß") "ss"))
    (ok (string= (casefold "Straße") "strasse"))
    (ok (string= (downcase "AbC") "abc"))
    (ok (string= (upcase "AbC") "ABC"))))

(deftest idna-bucher
  (capability-or-skip :idna
    (ok (string= (idna-name-to-ascii "bücher.de") "xn--bcher-kva.de"))
    (ok (string= (idna-name-to-unicode "xn--bcher-kva.de") "bücher.de"))))
