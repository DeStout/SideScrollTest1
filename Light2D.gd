extends Light2D

var red = Color(1, 0, 0)
var blue = Color(0, 0, 1)

func _on_Timer_timeout():
	if color == red:
		color = blue
	else:
		color = red
