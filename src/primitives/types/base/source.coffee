Primitive = require '../../primitive'

class Source extends Primitive
  @traits: ['node', 'data', 'source']

  constructor: (node, context, helpers) ->
    super node, context, helpers

  callback: (callback) ->
    callback ? () ->

  sourceShader: () ->

  getDimensions: () ->
    items:  1
    width:  0
    height: 0
    depth:  0

  getActive: () ->
    items:  1
    width:  0
    height: 0
    depth:  0



module.exports = Source