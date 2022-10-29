extends KinematicBody2D

var direction: Vector2 = Vector2.ZERO
export(int) var speed: int = 250 setget , get_speed
export(int) var four_bounce_modifier: int = 50
export(int) var twelve_bounce_modifier: int = 150
export(int) var struck_orange_modifier: int = 30
export(int) var struck_red_modifier: int = 60
export(Vector2) var start_position = Vector2(300, 752)
var bounce_count = 0
var is_launched: bool = false
var has_struck_orange: bool = false
var has_struck_red: bool = false

signal collision_with_tile(tile_name)
signal struck_ceiling()
signal launched()
signal ball_left_screen()

func _ready() -> void:
  reset(start_position, true)

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed('launch') and not is_launched:
    direction = Vector2.UP.rotated(deg2rad(rand_range(-10, 10))).normalized()
    is_launched = true
    emit_signal('launched')

func _physics_process(delta: float) -> void:
  var collision = move_and_collide(direction * self.speed * delta)
  if collision:
    if collision.collider.name == "Paddle":
      $PaddleSound.play()
    elif collision.collider.name == "WallsAndCeiling":
      $WallSound.play()
    else:
      $BlockSound.play()
    if collision.collider is TileMap:
      var tile: int = collision.collider.get_cellv(collision.collider.world_to_map(collision.position))
      if tile == 1:
        emit_signal('struck_ceiling')
    direction = direction.bounce(collision.normal)
    if collision.collider is KinematicBody2D:
      direction = (position - collision.collider.get_node("Anchor").global_position).normalized()
    elif collision.collider.is_in_group("block"):
      emit_signal('collision_with_tile', collision.collider.name)
      if collision.collider.is_in_group("orange"):
        has_struck_orange = true
      if collision.collider.is_in_group("red"):
        has_struck_red = true
      collision.collider.queue_free()
      bounce_count = bounce_count + 1

func get_speed() -> int:
  if not is_launched:
    return 0
  if bounce_count > 11:
    return speed + twelve_bounce_modifier + (struck_orange_modifier if has_struck_orange else struck_red_modifier if has_struck_red else 0)
  if bounce_count > 3:
    return speed + four_bounce_modifier + (struck_orange_modifier if has_struck_orange else struck_red_modifier if has_struck_red else 0)
  return speed

func reset(start_pos: Vector2, restart: bool = false) -> void:
  position = Vector2(start_pos.x, 752)
  direction = Vector2.ZERO
  is_launched = false
  if restart:
    bounce_count = 0
    has_struck_orange = false
    has_struck_red = false

func follow_paddle(paddle_position: Vector2) -> void:
  if not is_launched:
    position.x = paddle_position.x

func _on_VisibilityNotifier2D_screen_exited() -> void:
  emit_signal('ball_left_screen')
