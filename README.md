# unicode-protocol

Lispy **CLOS** Unicode for [cl-stack](https://github.com/egao1980/cl-stack) — ICU-shaped, not a cl-unicode export mirror.

| System | Nick | Role |
|--------|------|------|
| `unicode-protocol` | `stack-unicode` | Properties, Normalizer2, case, IDNA/UTS#46, BreakIterator, UnicodeSet |

**Not here:** MessageFormat / locales / collation / number·date format → [`i18n-protocol`](https://github.com/egao1980/i18n-protocol) + [`l10n-protocol`](https://github.com/egao1980/l10n-protocol). Octets↔string stays **Babel** ([text-unicode](https://github.com/egao1980/cl-stack/blob/main/docs/capabilities/text-unicode.md)).

## Shape

| ICU | This protocol |
|-----|----------------|
| `u_hasBinaryProperty` / `UCharacter.hasBinaryProperty` | `binary-property-p` / `alphabetic-p` … |
| `u_getIntPropertyValue` | `int-property` / `general-category` / `script` |
| `Normalizer2` | `normalize` / `normalized-p` / `quick-check` (`:nfc`…`:nfkc-casefold`) |
| `u_strFoldCase` (root) | `casefold` / `downcase` / `upcase` / `titlecase` |
| `IDNA` / UTS #46 | `idna-name-to-ascii` / `idna-map` … |
| `BreakIterator` | `make-break-iterator` / `map-breaks` |
| `UnicodeSet` | `make-unicode-set` / `uset-contains-p` / `uset-span` |

```lisp
(asdf:load-system "unicode-backend-icu")   ; forthcoming
(stack-unicode:normalize "é" :form :nfc)
(stack-unicode:alphabetic-p #\A)
(stack-unicode:idna-name-to-ascii "bücher.de")
```

Backends (planned): `unicode-backend-icu` (ICU4C overlays), `unicode-backend-cl-unicode`, `unicode-backend-sbcl`.

`cl-idna` will rearrange onto this protocol later.

## License

MIT
