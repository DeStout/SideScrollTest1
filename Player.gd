extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 150
var times_attacked = 0

func _physics_process(delta):
	if times_attacked >= 3:
		get_tree().reload_current_scene()
		
	get_input()
	set_sprite()
	
	z_index = position.y
	velocity = move_and_slide(velocity)

func get_input():
	if $stall_timer.is_stopped():
		$Attack_Collision/Attack_Collision.disabled = true
		if Input.is_action_just_pressed("Attack"):
			attack()
		elif Input.is_action_pressed("Run"):
			speed = 200
		else:
			speed = 150
		
	velocity.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	velocity.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	velocity = velocity.normalized() * speed
	
func attack():
	speed = 0
	$stall_timer.start()
	if $Animator.flip_h == false:
		$Attack_Collision/Attack_Collision.position.x = 30
	else:
		$Attack_Collision/Attack_Collision.position.x = -30
	$Attack_Collision/Attack_Collision.disabled = false
	$Damage_Collision/Head_Collision.position.y = -34.5
	$Damage_Collision/Torso_Collision.position.y = -6.5
	
func set_sprite():
	if !$stall_timer.is_stopped():
		$Animator.play("Attack")
	elif velocity.length() > 0:
		$Animator.play("Walk")
	else:
		$Animator.play("Idle")
		$Damage_Collision/Head_Collision.position.y = -37.5
		$Damage_Collision/Torso_Collision.position.y = -9.5
			
	if velocity.x > 0:
		$Animator.flip_h = false
		$Damage_Collision/Head_Collision.position.x = 0.5
		$Damage_Collision/Head_Collision.position.y = -37.5
		$Damage_Collision/Torso_Collision.position.x = 0
		$Damage_Collision/Torso_Collision.position.y = -9.5
	elif velocity.x < 0:
		$Animator.flip_h = true
		$Damage_Collision/Head_Collision.position.x = -0.5
		$Damage_Collision/Head_Collision.position.y = -37.5
		$Damage_Collision/Torso_Collision.position.x = 0
		$Damage_Collision/Torso_Collision.position.y = -9.5

func _on_Damage_Collision_area_entered(area):
	if area.get_name() == "Attack_Collision":
		var enemy_height = area.get_parent().position.y
		var min_collide = position.y - ($Feet_Collision.shape.extents.y * 2)
		var max_collide = position.y + ($Feet_Collision.shape.extents.y * 2)
		
		if enemy_height > min_collide && enemy_height < max_collide:
			times_attacked += 1