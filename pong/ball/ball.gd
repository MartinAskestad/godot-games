extends KinematicBody2D

var direction := Vector2.ZERO
var start_direction: int
var bounce_counter := 0
enum BounceAngles {
  A = -15,
  B = -10,
  C = -5,
  D = 5,
  E = 10,
  F = 15
}
export (int) var speed = 250 setget , get_speed

func get_speed() -> int:
  if bounce_counter < 4:
    return speed
  elif bounce_counter < 11:
    return speed + 150
  return speed + 250

func _ready():
  reset()

func _physics_process(delta):
  var _res := move_and_slide(direction * self.speed, Vector2.UP)
  if is_on_ceiling() or is_on_floor():
    direction = Vector2(direction.x, -direction.y)
    return
  var collision: KinematicCollision2D = get_last_slide_collision()
  if collision and BounceAngles.get(collision.collider_shape.name) == null:
    direction = Vector2(-direction.x, direction.y)
  elif collision and BounceAngles.get(collision.collider_shape.name):
    handle_collision(direction.x < 0, BounceAngles.get(collision.collider_shape.name))
  if collision:
    bounce_counter = bounce_counter + 1
    $Bounce.play()

func handle_collision(player_paddle: bool, angle: int) -> void:
  var normal := Vector2.RIGHT if player_paddle else Vector2.LEFT
  var return_angle: int = angle + (-angle_modifier() if angle < 0 else angle_modifier())
  var return_vector := normal.rotated(deg2rad(return_angle)).normalized()
  direction = return_vector

func angle_modifier() -> int:
  if bounce_counter < 4:
    return 0
  elif bounce_counter < 11:
    return 15
  return 25

func reset(start_dir = -1) -> void:
  bounce_counter = 0
  direction = Vector2.ZERO
  start_direction = start_dir
  $StartRestartTimer.start()

func _on_StartRestartTimer_timeout():
  direction = Vector2(start_direction, 0)
