extends Node2D

onready var yellow_block = preload('res://blocks/Yellow.tscn')
onready var green_block = preload('res://blocks/Green.tscn')
onready var orange_block = preload('res://blocks/Orange.tscn')
onready var red_block = preload('res://blocks/Red.tscn')

var launched: bool = false setget set_launched
var current_level: int = 1
var balls: int = 3
var remaining_blocks: int = 0

func _ready() -> void:
  randomize()
  reset(true)

func set_launched(val:bool) -> void:
  if launched != val:
    $UI.toggle_start_message(val)
  launched = val

func reset(restart: bool) -> void:
  if restart:
    $UI.score = 0
    $UI.balls_left = 3
    balls = 3
    current_level = 1
    self.launched = false
    $UI.reset()
    $Ball.reset($Paddle.position, true)
  else:
    current_level = 2
    $Ball.reset($Paddle.position)
  # Create the blocks

  for i in 28:
    var block_position: Vector2 = Vector2(40 * (i % 14), 0 if i < 14 else 20)
    var y = yellow_block.instance(PackedScene.GEN_EDIT_STATE_MAIN)
    y.name = "Yellow" + str(i)
    var g = green_block.instance(PackedScene.GEN_EDIT_STATE_MAIN)
    g.name = "Green" + str(i)
    var o = orange_block.instance(PackedScene.GEN_EDIT_STATE_MAIN)
    o.name = "Orange" + str(i)
    var r = red_block.instance(PackedScene.GEN_EDIT_STATE_MAIN)
    r.name = "Red" + str(i)
    y.position = block_position
    g.position = block_position
    o.position = block_position
    r.position = block_position
    $Blocks/Yellows.add_child(y)
    $Blocks/Greens.add_child(g)
    $Blocks/Oranges.add_child(o)
    $Blocks/Reds.add_child(r)

func _on_Ball_collision_with_tile(tile_name: String) -> void:
  var tile_color: String = tile_name.substr(0, 1)
  var current_score: int = $UI.score
  match tile_color:
    "Y":
      current_score = current_score + 1
    "G":
      current_score = current_score + 3
    "O":
      current_score = current_score + 5
    "R":
      current_score = current_score + 7
  $UI.score = current_score
  if current_score == 448:
    reset(false)
  if current_score == 896:
    $UI.show_game_over()

func _on_Ball_launched() -> void:
  self.launched = true

func _on_Ball_ball_left_screen() -> void:
  #balls = balls - 1
  $UI.balls_left = balls
  if balls > 0:
    $Ball.reset($Paddle.position)
  else:
    $UI.show_game_over()
    $GameOverTimer.start()

func _on_Ball_struck_ceiling() -> void:
  $Paddle.shrink()

func _on_Paddle_moved(position) -> void:
  $Ball.follow_paddle(position)

func _on_GameOverTimer_timeout() -> void:
  print("timeout")
  reset(true)
