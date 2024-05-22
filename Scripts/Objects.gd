class_name Objects

static func invoke(object: Object, method: String) -> void:
  if object.has_method(method):
    object.call(method)