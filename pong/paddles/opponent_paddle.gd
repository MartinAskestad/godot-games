extends KinematicBody2D

export(int) var speed = 250
export(int, 20, 40) var move_tollerance = 25
var direction = Vector2.ZERO
var ball_position: Vector2 = Vector2.ZERO setget set_ball_position

func set_ball_position(position: Vector2) -> void:
  ball_position = position

func _physics_process(delta):
  var _res = move_and_slide(direction * speed)
  find_direction()

func find_direction() -> void:
  if ball_position == Vector2.ZERO:
    return
  if abs(ball_position.y - position.y) > move_tollerance:
    direction = Vector2.DOWN if ball_position.y > position.y else Vector2.UP
