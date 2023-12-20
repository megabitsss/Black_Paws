extends CharacterBody2D

var mov = Vector2.RIGHT	
var movement_speed = 40.0
var hp = 80
var last_movement = Vector2.UP

#IceSpear
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")

#AttackNodes
@onready var iceSpearTimer = $Attack/IceSpearTimer
@onready var iceSpearAttackTimer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornadoTimer = $Attack/TornadoTimer
@onready var tornadoAttackTimer = $Attack/TornadoTimer/TornadoAttackTimer

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 5
var tornado_attackspeed = 3
var tornado_level = 1


#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = $walkTimer
@onready var anim = $AnimationPlayer

func _ready():	
	attack()

func _physics_process(delta):
	movement()
	
func movement():
	var x_move = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_move = Input.get_action_strength("down") - Input.get_action_strength("up")
	mov = Vector2(x_move, y_move)
	
	if mov.x >0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
		
	if mov != Vector2.ZERO: #if running
		last_movement = mov #the current side that facing
		anim.play("walking")
	else:
		anim.play("idle")
	velocity = mov.normalized() * movement_speed #make it into radius
	move_and_slide() #moves the player based on velocity (already associated with delta) **

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
			
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	
func _on_hurt_box_hurt(damage, _angle, _knockback): #trigger this singal after get hit
	hp -= damage
	print("Current hp", hp)

func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo #baseammo is maximum ammo per one reload
	iceSpearAttackTimer.start()

func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target() #set up the target
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start() #repeat again til out of magazine
		else:
			iceSpearAttackTimer.stop()

func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo #baseammo is maximum ammo per one reload
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start() #repeat again til out of magazine
		else:
			tornadoAttackTimer.stop()
	
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body): #detect
	if enemy_close.has(body):
		enemy_close.erase(body)


