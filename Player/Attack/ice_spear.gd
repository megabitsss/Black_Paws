extends Area2D

var level = 1
var hp = 1
var speed =  100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO #we'll set target in player node (target_random)
var angle = Vector2.ZERO

@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_play
@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() #this node attribute, not a variable
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 0.75 * (1+player.spell_size)
		2: #just increase bullet project so in this node it still remains the same
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 0.75 * (1+player.spell_size)
		3:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 0.75 * (1+player.spell_size)
		4:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 0.75 * (1+player.spell_size)
	
	anim.play("fire")
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
			
func _physics_process(delta):
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		
		collision.call_deferred("set", "disabled", true)
		anim.hide()
		await sound.finished #await waits for the signal, so we need to use signal
		queue_free()
#		

func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free() #delete it after 10 secs
