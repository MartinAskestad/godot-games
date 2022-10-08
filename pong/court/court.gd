extends Sprite


func _ready():
  pass


func _on_VisibilityNotifier2D_screen_exited():
  if $Ball.position.x > 300:
    $Ball.reset(1)
  else:
    $Ball.reset(-1)
  $Ball.position = Vector2(400, 300)


func _on_OpponentTimer_timeout():
  $OpponentPaddle.ball_position = $Ball.position
