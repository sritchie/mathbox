###
Virtual RenderTarget that cycles through multiple frames
Provides easy access to past rendered frames
@reads[] and @write contain WebGLRenderTargets whose internal pointers are rotated automatically
###
class RenderTarget
  constructor: (@gl, width, height, frames, options = {}) ->
    options.minFilter ?= THREE.NearestFilter
    options.magFilter ?= THREE.NearestFilter
    options.format    ?= THREE.RGBAFormat
    options.type      ?= THREE.UnsignedByteType

    @options = options

    @width   = width  || 1
    @height  = height || 1
    @frames  = frames || 1
    @buffers = @frames + 1

    @build()

  build: () ->

    make = () => new THREE.WebGLRenderTarget @width, @height, @options

    @targets = (make() for i in [0...@buffers])
    @reads   = (target.texture for target in @targets)
    @write   = @targets[@buffers-1]

    # Texture access uniforms
    @uniforms =
      dataResolution:
        type: 'v2'
        value: new THREE.Vector2 1 / @width, 1 / @height
      dataTexture:
        type: 't'
        value: @reads[0]
      dataTextures:
        type: 'tv'
        value: @reads

  cycle: () ->
    @targets.unshift(@targets.pop())
    @write = @targets[@buffers-1]
    @reads.unshift(@reads.pop())
    @uniforms.dataTexture.value = @reads[0]

  warmup: (callback) ->
    for i in [0...@buffers]
      callback @write
      @cycle()

  dispose: () ->
    target.dispose() for target in @targets
    @targets = @reads = @write = null

module.exports = RenderTarget