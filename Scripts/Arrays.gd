class_name Arrays

static func flatten(a: Array, out: Array = [ ]) -> Array:
  for item in a:
    if item is Array:
      flatten(item, out)
    else:
      out.append(item)
  return out

static func dedupe(a: Array, out: Array = [ ]) -> Array:
  for item in a:
    if not item in out:
      out.append(item)
  return out