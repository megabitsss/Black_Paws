extends Area2D

var target = null
var speed = -1

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var snd = $snd_collected

signal pickup_all_signal

func _ready():
	connect("pickup_all_signal", Callable(player, "pickup_all_start"))

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta
	
func collect():
	snd.play()
	emit_signal("pickup_all_signal")
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return 0

func _on_snd_collected_finished():
	queue_free()
	

