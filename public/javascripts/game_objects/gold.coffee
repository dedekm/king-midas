Item = require './item.coffee'

class Gold extends Item
  constructor: (scene, x, y, amount) ->
    super scene, x, y, 'coin'
    
    @category = 'gold'
    @value = amount

module.exports = Gold
