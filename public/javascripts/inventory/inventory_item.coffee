class InventoryItem
  constructor: (inventory, item, position) ->
    @inventory = inventory
    @list = [item]
    
    @position = position
    @images = []
    
    @category = item.category || item.texture.key
    @value = item.value
    
    if @category == 'gold'
      @amount = item.value
    else
      @amount = 1
    
    @x = @inventory.baseX + position * 32
    @y = @inventory.baseY
    @images.push @inventory.scene.add.image(@x, @y, item.texture.key)
    @text = @inventory.scene.add.text(@x, @y, @amount)
    
  add: (item) ->
    @list.push item
    @value += item.value
    
    if @category == 'gold'
      @amount += item.value
    else
      @amount++
      @images.push @inventory.scene.add.image(@x, @y - 6 * (@amount - 1), item.texture.key)
      
    @text.setText @amount

module.exports = InventoryItem
