extends Area2D

var level = 1
var hp = 9999
var speed = 200.0
var damage = 10
var knockback_amount = 100
var paths = 1
var attack_size = 1.0
var attack_speed = 5.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var iceaxe_reg = preload("res://Player/Attack/iceAxe.png")
var iceaxe_attack = preload("res://Player/Attack/iceAxeAttack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attackTimer = $AttackTimer
@onready var changeDirectionTimer = $ChangeDirection
@onready var resetPostTimer = $ResetPostTimer
@onready var snd_attack = $snd_attack

signal remove_from_array(object)

func _ready():
	update_iceaxe()
	_on_reset_post_timer_timeout()


func update_iceaxe():
	level = player.iceaxe_level
	match level:
		1:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 1 #amount of an attack
			attack_size = 0.75 * (1+player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		2:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 2 #amount of an attack
			attack_size = 0.75 * (1+player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		3:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 3 #amount of an attack
			attack_size = 0.75 * (1+player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
		4:
			hp = 9999
			speed = 200.0
			damage = 15
			knockback_amount = 120
			paths = 3 #amount of an attack
			attack_size = 0.75* (1+player.spell_size)
			attack_speed = 5.0 * (1-player.spell_cooldown)
			
	scale = Vector2(1.0, 1.0) * attack_size
	attackTimer.wait_time = attack_speed
	
	

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle * speed * delta
	else: #ถ้า array โดนลบจนหมดเมื่อไหร่ก็กลับมา cooldown รอ attackTimer ให้หมดเวลาต่อไป
		#iceaxe ตอน cooldown จะไม่ไปไกลเกินกว่า reset_pos เพราะ _physics_process ปรับ angle ให้ไปทาง reset_pos ตลอด ต่อให้เลยมันก็จะกลับมา
		var player_angle = global_position.direction_to(reset_pos)
		var distance_dif = global_position - player.global_position
		var return_speed = 20
		if abs(distance_dif.y) > 500 or abs(distance_dif.x) > 500:
			return_speed = 100
		position += player_angle * return_speed * delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(45) #always rotate to play if cooldown
func add_paths(): #every 5 sec, create array of target
	snd_attack.play()
	emit_signal("remove_from_array", self) #we've declared that signal, เอาตัวเองออกจาก array
	target_array.clear()
	var counter = 0
	while counter < paths: #paths = 1
		var new_path = player.get_random_target() #adding array of target based on paths
		target_array.append(new_path)
		counter += 1
	enable_attack(true)
	target = target_array[0]
	process_path()

func process_path():
	snd_attack.play()
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()
	var tween = create_tween()
	var new_rotation_degree = angle.angle() + deg_to_rad(45)
	tween.tween_property(self, "rotation", new_rotation_degree, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func enable_attack(atk = true): #just setting the texture
	if atk:
		collision.call_deferred("set", "disabled", false)
		sprite.texture = iceaxe_attack
	else:
		collision.call_deferred("set", "disabled", true)
		sprite.texture = iceaxe_reg

func _on_attack_timer_timeout():
	add_paths()


func _on_change_direction_timeout(): #หมดเวลาหลัง 1 วิ ไม่สนว่าโดน target มั้ย
	if target_array.size() > 0:
		target_array.remove_at(0) #เปลี่ยนเป้าหมาย
		if target_array.size() > 0:
			target = target_array[0]
			process_path() #setting angle and attack
			emit_signal("remove_from_array", self)
		else:
			changeDirectionTimer.stop()
			attackTimer.start()
			enable_attack(false)
	else:
		changeDirectionTimer.stop()
		attackTimer.start()
		enable_attack(false)


func _on_reset_post_timer_timeout(): #every 3 sec, random a position for iceAxe
	var choose_direction = randi() % 4
	reset_pos = player.global_position
	match choose_direction:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2: 
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
