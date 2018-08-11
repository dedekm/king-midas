preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'

config =
  type: Phaser.AUTO
  width: 640
  height: 480
  pixelArt: true
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
