; extends

; Conceal className attribute values in JSX/TSX files
(jsx_attribute
  (property_identifier) @att_name
  (#eq? @att_name "className")
  [
    (string
      (string_fragment) @css_class_attr_value)
    (jsx_expression
      (template_string) @css_class_attr_value)
  ]
  (#set! @css_class_attr_value conceal "…"))
