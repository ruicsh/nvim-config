; extends

; CSS class value on HTML `class` attribute
(attribute
  (attribute_name) @att_name
  (#eq? @att_name "class")
  (quoted_attribute_value
    (attribute_value) @css_class_attr_value))
