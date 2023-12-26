extends "res://Enemy/enemy.gd"

@export var projectile_amount = 8 #360/projectile_amount
@export var projectile_speed = 75
@export var projectile_cooldown = 5
@export var projectile_attack_size = 0.75
@export var enemy_radius = 260

@onready var attackTimer = $Attack
@onready var projectileTimer = $Attack/ProjectileCooldown
@onready var projectile = preload("res://Enemy/magic_ball.tscn")
@onready var animation = $AnimationPlayer
@onready var collision_detection = $PlayerDetection/CollisionShape2D

@onready var projectile_node = $Projectile

var target_to_player = Vector2.ZERO
var projectile_count = 0
var detect_player = false
var main_script = load("res://Enemy/enemy.gd")
var angle_to_player = Vector2.ZERO

signal remove_after

func _ready():
	connect("update_killing_signal", Callable(player, "update_killing"))
	anim.play("walking")
	hitBox.damage = enemy_damage
	attackTimer.wait_time = projectile_cooldown
	collision_detection.shape.radius = enemy_radius
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery) #gradually reducing this vector
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	
	if not detect_player:
		anim.play("walking")
		velocity = direction * movement_speed
	elif detect_player and not attackTimer.is_stopped():
		anim.play("casting")
		velocity = Vector2.ZERO
		
	if direction.x > 0.1:
		sprite.flip_h = flipR
	elif direction.x < -0.1:
		sprite.flip_h = flipL
	
	move_and_slide()

func _on_projectile_cooldown_timeout():
	if projectile_count > 0:
		anim.play("attacking")
		var magicBall = projectile.instantiate()
		magicBall.angle = angle_to_player
		magicBall.position = global_position
		magicBall.speed = projectile_speed
		magicBall.attack_size = projectile_attack_size
		add_child(magicBall)
		projectile_count -= 1
		projectileTimer.start()
	else:
		projectileTimer.stop()
		projectile_count = 0
		if detect_player: #if player is stills in the area then attack again
			attackTimer.start()

func _on_attack_timeout():
	projectile_count += projectile_amount
	projectileTimer.start()
	
func _on_player_detection_body_entered(body):
	if body.is_in_group("player") and not detect_player:
		detect_player = true
		angle_to_player = global_position.direction_to(body.global_position)
		attackTimer.start()

func _on_player_detection_body_exited(body):
	if body.is_in_group("player"):
		print("Out")
		detect_player = false
		attackTimer.stop()
		attackTimer.wait_time = projectile_cooldown

#Current problem, projectile is queue_free() after the enemy is queue_free() suddenly
