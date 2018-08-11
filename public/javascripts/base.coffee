preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'

config =
  type: Phaser.AUTO
  width: 800
  height: 600
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
