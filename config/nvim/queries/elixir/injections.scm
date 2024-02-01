; extends

; SQL
; (sigil
;   (sigil_name) @_sigil_name
;   (quoted_content) @sql
; (#eq? @_sigil_name "Q"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "Q")
 (#set! injection.language "sql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "L")
 (#set! injection.language "html"))
