extends TileMap

var level_tiles: Array = []
onready var neighbors: Array = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
var solution: Array = [0, 1, 2, 3, 4, 5, 6, 7, 9]

func _ready():
  randomize()
  for y in 3:
    for x in 3:
      level_tiles.append(Vector2(x, y))
  shuffle()

func _input(event):
  if event is InputEventMouseButton:
    if event.pressed:
      var mouse_position: Vector2 = event.position - position
      var map_position = world_to_map(mouse_position)
      var cell = get_cellv(map_position)
      if cell >= 0 and cell <= 7:
        slide(map_position, true)

func slide(tile_position: Vector2, check_for_solution = false) -> void:
  # Find empty neighbor position
  for neighbor in neighbors:
    var neighbor_position = tile_position + neighbor
    if get_cellv(neighbor_position) == 9:
      set_cellv(neighbor_position, get_cellv(tile_position))
      set_cellv(tile_position, 9)
      if check_for_solution and check_solved():
        $WinJingle.play()
        $RestartTimer.start()
      break

func check_solved() -> bool:
  var current = []
  for t in 9:
    var x = t % 3
    var y = (t - x) / 3
    current.append(get_cell(x, y))
  return current == solution

func shuffle():
  var number_of_passes = randi() % 151 + 10
  for _i in number_of_passes:
    # Find the empty slot
    for t in level_tiles:
      if get_cellv(t) == 9:
        # Find random neighbor and slide
        var neighbor = t + neighbors[randi() % len(neighbors)]
        while get_cellv(neighbor) == -1:
          neighbor = t + neighbors[randi() % len(neighbors)]
        slide(neighbor)
        break

func _on_RestartTimer_timeout() -> void:
  shuffle()
