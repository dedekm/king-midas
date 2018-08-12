class CustomPlugin extends Phaser.Plugins.BasePlugin
  constructor: (pluginManager) ->
    super(pluginManager);
    pluginManager.registerGameObject('custom', this.createCustom)

  createCustom: (klass, x, y, key, frame) ->
    pixelX = x * @scene.tileSize + @scene.tileSizeHalf
    pixelY = y * @scene.tileSize + @scene.tileSizeHalf
    
    custom = new klass(@scene, pixelX, pixelY, key, frame)
    
    @scene.totalValueDirty = true if custom.value
    
    custom.tileX = x
    custom.tileY = y
    @scene.objects.add custom
    @displayList.add custom

module.exports = CustomPlugin
