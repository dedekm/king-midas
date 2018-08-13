class CustomPlugin extends Phaser.Plugins.BasePlugin
  constructor: (pluginManager) ->
    super(pluginManager);
    pluginManager.registerGameObject('custom', this.createCustom)

  createCustom: (klass, x, y, key, frame) ->
    custom = new klass(@scene, x, y, key, frame)
    
    @scene.totalValueDirty = true if custom.value
    @scene.objects.add custom
    @displayList.add custom

module.exports = CustomPlugin
