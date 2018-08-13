preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'

CustomPlugin = require './plugin.coffee'

config =
  type: Phaser.AUTO
  width: 1160
  height: 580
  pixelArt: true
  plugins:
    global: [
        { key: 'CustomPlugin', plugin: CustomPlugin, start: true }
    ]
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
