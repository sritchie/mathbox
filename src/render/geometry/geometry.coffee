debug = false

tick = () ->
  now = +new Date
  return (label) ->
    delta = +new Date() - now
    console.log label, delta + " ms"
    delta

class Geometry extends THREE.BufferGeometry
  constructor: () ->
    THREE.BufferGeometry.call @
    @uniforms ?= {}
    @groups  ?= []

  _reduce: (dims, maxs) ->
    multiple = false
    for dim, i in dims
      max = maxs[i]
      if multiple
        dims[i] = max
      if dim > 1
        multiple = true

    quads = dims.reduce (a, b) -> a * b

  _emitter: (name) ->
    if name == 'index'
      attribute = @index
    else
      attribute = @attributes[name]
    dimensions = attribute.itemSize
    array      = attribute.array

    offset = 0

    one = (a) ->
      array[offset++] = a
    two = (a, b) ->
      array[offset++] = a
      array[offset++] = b
    three = (a, b, c) ->
      array[offset++] = a
      array[offset++] = b
      array[offset++] = c
    four = (a, b, c, d) ->
      array[offset++] = a
      array[offset++] = b
      array[offset++] = c
      array[offset++] = d

    [null, one, two, three, four][dimensions]

  _finalize: () ->
    return

  _offsets: (offsets) ->
    @groups = offsets


module.exports = Geometry