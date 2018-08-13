Item = require './item.coffee'

class Gold extends Item
  constructor: (scene, x, y, amount) ->
    super scene, x, y, 'gold1'
    
    @category = 'gold'
    @value = amount
  
  addItem: (item) ->
    throw 'Items must be in the same category' if item.category != @category
    @value += item.value
  
  pickUpItems: (amount) ->
    @value -= amount
    new Gold(@scene, 0, 0, amount)
    
module.exports = Gold
