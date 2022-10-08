extends KinematicBody2D

export (int) var speed := 300

func _physics_process(delta):
  var up_or_down := Input.get_action_strength('player_1_down') - Input.get_action_strength('player_1_up')
  move_and_slide(Vector2(0, up_or_down) * speed)
