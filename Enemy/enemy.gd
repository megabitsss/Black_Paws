extends CharacterBody2D

@export var movement_speed = 25.0
@export var hp = 10
@export var experience = 1
@export var enemy_damage = 1
@export var knockback_recovery = 3.5
@export var knockback = Vector2.ZERO
@export var flipR = false
@export var flipL = true

@onready var player = get_tree().get_first_node_in_group("player") #asking the tree to give the first node in 'that' group
@onready var loot_base = get_tree().get_first_node_in_group("loot") #add to world/loot (just a node which is a first in a group)
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit
@onready var hitBox = $HitBox
@onready var hurtBox = $HurtBox
@onready var collision = $CollisionShape2D

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Object/exp_gem.tscn")
var gingerbread = preload("res://Object/gingerbread.tscn")

#Performance
var screen_size

signal remove_from_array(object)
signal update_killing_signal()

func _ready():
	add_to_group("enemy")
	connect("update_killing_signal", Callable(player, "update_killing"))
	anim.play("walking")
	hitBox.damage = enemy_damage
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery) #gradually reducing this vector
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = flipR
	elif direction.x < -0.1:
		sprite.flip_h = flipL

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale / 2
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	
	#Exp
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	
	#Gingerbread
	var chance = randi() % 450
	if chance < 1:
		var new_gingerbread = gingerbread.instantiate()
		new_gingerbread.global_position = global_position
		loot_base.call_deferred("add_child", new_gingerbread)
	
	player.killed_enemy += 1
	emit_signal("update_killing_signal")
	queue_free() #destroyed

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage #this is player damage that we took from the function
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()

func _on_invisible_timer_timeout():
	var location_diff = global_position - player.global_position
	if abs(location_diff.x) > (screen_size.x/2)*1.4 or abs(location_diff.y) > (screen_size.y/2)*1.4:
		sprite.visible = false
	else:
		sprite.visible = true
		
func frame_save(default = 20):
	var random = randi() % 100
	if random < default:
		collision.call_deferred("set", "disabled", true)
		anim.stop()
