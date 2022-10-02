extends TileMap

var body: Array = []
var direction = Vector2.LEFT
var ate = false
var apple: Vector2
var move_queued = false

onready var head_id = tile_set.find_tile_by_name("head")
onready var tail_id = tile_set.find_tile_by_name("tail")
onready var segment_id = tile_set.find_tile_by_name("segment")
onready var turn_id = tile_set.find_tile_by_name("turn")
onready var apple_id = tile_set.find_tile_by_name("apple")

func _ready() -> void:
  restart_game()
  spawn_apple()
  draw_game()

func restart_game() -> void:
  randomize()
  var screen_center = get_viewport().get_visible_rect().size * 0.5
  var center_of_map = world_to_map(screen_center)
  body = [center_of_map + Vector2.LEFT, center_of_map, center_of_map + Vector2.RIGHT]
  direction = Vector2.LEFT

func draw_game() -> void:
  clear()
  # draw apple
  set_cellv(apple, apple_id)
  # draw head
  var head_direction = body[1] - body.front()
  set_cellv(body.front(), head_id,
    head_direction == Vector2.RIGHT,
    head_direction == Vector2.DOWN,
    head_direction == Vector2.DOWN or head_direction == Vector2.UP)
  # draw tail
  var tail_direction = body.back() - body[-2]
  set_cellv(body.back(), tail_id,
    tail_direction == Vector2.RIGHT,
    tail_direction == Vector2.DOWN,
    tail_direction == Vector2.DOWN or tail_direction == Vector2.UP)
  # draw segments
  for segment_idx in range(1, len(body) - 1):
    var current_segment = body[segment_idx]
    var previous_segment = body[segment_idx - 1] - current_segment
    var next_segment = body[segment_idx + 1] - current_segment
    var in_line = previous_segment.x == next_segment.x or previous_segment.y == next_segment.y
    if in_line:
      set_cellv(current_segment, segment_id,
        false,
        false,
        previous_segment == Vector2.DOWN or previous_segment == Vector2.UP)
    else:
      var top_right_corner = (previous_segment == Vector2.LEFT and next_segment == Vector2.DOWN) or (previous_segment == Vector2.DOWN and next_segment == Vector2.LEFT)
      var bottom_right_corner = (previous_segment == Vector2.UP and next_segment == Vector2.LEFT) or (previous_segment == Vector2.LEFT and next_segment == Vector2.UP)
      var top_left_corner = (previous_segment == Vector2.DOWN and next_segment == Vector2.RIGHT) or (previous_segment == Vector2.RIGHT and next_segment == Vector2.DOWN)
      set_cellv(current_segment, turn_id,
        top_right_corner or bottom_right_corner,
        top_right_corner or top_left_corner)

func _on_UpdateSnake_timeout() -> void:
  var ate_modifier = 1 if ate else 2
  var snake_copy = body.slice(0, len(body) - ate_modifier)
  var snake_head = body.front() + direction
  snake_copy.push_front(snake_head)
  body = snake_copy
  ate = false
  move_queued = false
  # check if ate apple
  if body.front() == apple:
    ate = true
    spawn_apple()
  # check if going of screen
  if (body.front().x < 0 or body.front().x > 14
     or body.front().y < 0 or body.front().y > 14):
    restart_game()
  # check if going through one-self
  if body.front() in body.slice(1, len(body) - 1):
    restart_game()
  draw_game()

func _input(event: InputEvent) -> void:
  if move_queued:
    return
  var input_direction = Vector2(
      event.get_action_strength("right") - event.get_action_strength("left"),
      event.get_action_strength("down") - event.get_action_strength("up")
   ).normalized()
  if input_direction == Vector2.ZERO or direction + input_direction == Vector2.ZERO:
    return
  direction = input_direction
  move_queued = true

func spawn_apple() -> void:
  var rnd = randi() % 225
  var apple_pos = Vector2(rnd % 15, (rnd - (rnd % 15)) / 15)
  while apple_pos in body:
    rnd = randi() % 225
    apple_pos = Vector2(rnd % 15, (rnd - (rnd % 15)) / 15)
  apple = apple_pos

func draw_apple() -> void:
  set_cellv(apple, apple_id)
