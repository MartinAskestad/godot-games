extends KinematicBody2D

signal moved(position)

export(float) var speed = 300
onready var has_shrunk: bool = false

func _ready() -> void:
  $AnimationPlayer.play('RESET')

func _physics_process(delta: float) -> void:
  var input_direction := Vector2(Input.get_action_strength('player_1_right') - Input.get_action_strength('player_1_left'), 0)
  move_and_slide(input_direction * speed)
  emit_signal('moved', position)

func reset() -> void:
  $AnimationPlayer.play("RESET")

func shrink() -> void:
  if not has_shrunk:
    $AnimationPlayer.play('shrink')
  has_shrunk = true
