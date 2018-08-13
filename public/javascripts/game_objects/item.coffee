Object = require './object.coffee'

class Item extends Object
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @type = 'item'
    @category = @texture.key
    @value = 10
    
    @init()

  init: () ->
    @list = [@]
    @scene.setGrid(@tileX, @tileY, 1)
    return @
    
  addItem: (item) ->
    throw 'Items must be in the same category' if item.category != @category
    
    @list.push item
    @value += item.value
    @scene.children.add item
    item.setPosition(@x, @y - 6 * (@list.length - 1), item.texture.key)
  
  pickUp: ->
    @scene.setGrid(@tileX, @tileY, 0)
    @scene.children.remove(@)
    
    for item in @list
      @scene.children.remove item
    @list.length = 0

module.exports = Item
