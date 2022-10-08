extends Sprite

func _on_VisibilityNotifier2D_screen_exited():
  if $Ball.position.x > 300:  # Player scored
    $Ball.reset(1)
    var score = int($PlayerScore.text) + 1
    $PlayerScore.text = str(score)
  else:                       # Opponent scored
    $Ball.reset(-1)
    var score = int($OpponentScore.text) + 1
    $OpponentScore.text = str(score)
  $Ball.position = Vector2(400, 300)

func _on_OpponentTimer_timeout():
  $OpponentPaddle.ball_position = $Ball.position
