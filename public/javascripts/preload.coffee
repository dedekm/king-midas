module.exports = ->
  @load.image('frame', '/images/frame.png')
  @load.image('inventory_slot', '/images/inventory_slot.png')
  @load.spritesheet('things', '/images/things.png', { frameWidth: 29, frameHeight: 29 });
  
  for character in ['demon', 'dragon', 'knight', 'scorpio', 'skeleton', 'troll']
    @load.spritesheet(character, "/images/#{character}.png", { frameWidth: 29, frameHeight: 36 });
    
  @load.image('tiles', '/images/tileset.png')
  @load.tilemapCSV('map', '/tilemaps/grid.csv')
  
  help = document.createElement('div')
  help.classList.add('help')
  help.innerHTML+='WSAD = move / drag with mouse = drop items from inventory' 
  document.body.appendChild(help)
