Phaser = require 'phaser'

preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'

CustomPlugin = require './plugin.coffee'

config =
  type: Phaser.AUTO
  title: 'King Midas'
  url: 'https://ldjam.com/events/ludum-dare/42/king-midas'
  version: '0.1'
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
