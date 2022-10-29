extends CanvasLayer

onready var score_label: Label = get_node("%Score")
onready var balls_left_rect: TextureRect = get_node("%BallsLeft")

export(int) var score: int setget set_score, get_score
export(int) var balls_left: int setget set_balls_left

func set_score(value: int) -> void:
  score_label.text = str(value)

func get_score() -> int:
  return int(score_label.text)

func set_balls_left(balls: int) -> void:
  balls_left_rect.rect_min_size = Vector2(balls * 22, 22)
  if balls == 0:
    balls_left_rect.visible = false

func toggle_start_message(on_off: bool) -> void:
  if on_off:
    $AnimationPlayer.play('fade_out_start_message')
  else:
    $AnimationPlayer.play_backwards('fade_out_start_message')

func show_game_over() -> void:
  $AnimationPlayer.play("fade_in_game_over")

func reset() -> void:
  balls_left_rect.visible = true
  score_label.text = "0"
  $AnimationPlayer.play('RESET')
