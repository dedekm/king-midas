class InventoryItem
  constructor: (item, amount) ->
    @list = [item]
    @amount = amount
    @type = item.texture.key
    @value = item.value
    
  add: (item) ->
    @list.push item
    @amout++
    @value += item.value

module.exports = InventoryItem
