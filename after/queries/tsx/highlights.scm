;; extends

((jsx_attribute
  (property_identifier) @att_name (#eq? @att_name "className")
  [
    ;; concel attr_value on `className="flex flex-col"`
    (string (string_fragment) @class_value)
    ;; conceal attr_value on `className={`flex flex-col ${foobar}`}`
    (jsx_expression (template_string) @class_value)
  ]
  (#set! @class_value conceal "…")))

