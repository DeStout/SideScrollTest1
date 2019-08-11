extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 100
var times_attacked = 0

func _physics_process(delta):
	if times_attacked >= 3:
		queue_free()
		
	z_index = position.y
	
	if $stall_timer.is_stopped():
		speed = 100
		$Attack_Collision/Attack_Collision.disabled = true
		if $VisibilityNotifier.is_on_screen():
			var distance_to_player = get_parent().get_node("Player").position - position
			if distance_to_player.length() < 30:
				attack()
			velocity = (distance_to_player).normalized() * speed
			velocity = move_and_slide(velocity)
	set_animation()
	
func attack():
	speed = 0
	$stall_timer.start()
	$Attack_Collision/Attack_Collision.disabled = false
	
	if $Animator.flip_h == false:
		$Attack_Collision/Attack_Collision.position.x = 32.5
	else:
		$Attack_Collision/Attack_Collision.position.x = -32.5
		
func set_animation():
	if !$stall_timer.is_stopped():
		$Animator.play("Attack")
	elif velocity.length() > 0:
		$Animator.play("Walk")
	else:
		$Animator.play("Idle")
		
	if velocity.x > 0:
		$Animator.flip_h = false
	elif velocity.x < 0:
		$Animator.flip_h = true

func _on_Damage_Collision_area_entered(area):
	if area.get_name() == "Attack_Collision":
		var player_height = area.get_parent().position.y
		var min_collide = position.y - ($Feet_Collision.shape.extents.y * 2)
		var max_collide = position.y + ($Feet_Collision.shape.extents.y * 2)\
		
		if player_height > min_collide && player_height < max_collide:
			times_attacked += 1
