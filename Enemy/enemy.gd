extends CharacterBody2D

@export var movement_speed = 25.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player") #asking the tree to give the first node in 'that' group
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit

var death_anim = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("walking")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery) #gradually reducing this vector
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
		
func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale / 2
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free() #destroyed

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
