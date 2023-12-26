extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var sndAttack = $sndAttack

signal remove_after

var speed = 100
var damage = 2
var angle = Vector2.ZERO
var knockback = 0
var attack_size = 0.5

signal hurt(damage, angle, knockback)

func _ready():
	sndAttack.play()
	anim.play("shoot")
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += speed * angle * delta


func _on_timer_timeout():
	queue_free()
	
	
