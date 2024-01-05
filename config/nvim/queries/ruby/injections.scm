; extends

(heredoc_body
  (heredoc_content) @injection.content
    (#set! injection.include-children)
    (#set! injection.language "embedded_template")
  (heredoc_end))
