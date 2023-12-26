extends CharacterBody2D

var mov = Vector2.RIGHT	
var movement_speed = 40.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP
var additional_attacks = 0

var experience = 0
var exp_level = 1
var collected_exp = 0
var passed_time = 0
var killed_enemy = 0

#IceSpear
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var iceaxe = preload("res://Player/Attack/ice_axe.tscn")

#AttackNodes
@onready var iceSpearTimer = $Attack/IceSpearTimer
@onready var iceSpearAttackTimer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornadoTimer = $Attack/TornadoTimer
@onready var tornadoAttackTimer = $Attack/TornadoTimer/TornadoAttackTimer
@onready var iceaxeBase = $Attack/iceaxeBase
@onready var healthBar = $GUILayer/GUI/HealthBar


#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attack = 0
var pickup_range = 9

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

#Iceaxe
var iceaxe_ammo = 0
var iceaxe_level = 0

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = $walkTimer
@onready var anim = $AnimationPlayer
@onready var catsnd = $CatSound
@onready var hurtSndTimer = $CatSound/HurtSndTimer
@onready var collision = $CollisionShape2D
@onready var collision_disable_timer = $CollisionShape2D/CollisionDisableTimer
@onready var pickup_area = $GrabArea/CollisionShape2D
@onready var pickupAllTimer = $GrabArea/PickupAllTimer

#GUI
@onready var expBar = $GUILayer/GUI/ExpBar
@onready var labelLevel = $GUILayer/GUI/ExpBar/lbl_level
@onready var levelPanel = $GUILayer/GUI/LevelUp
@onready var upgradeOption = $GUILayer/GUI/LevelUp/UpgradeOptions
@onready var snd_levelup = $GUILayer/GUI/LevelUp/snd_levelup
@onready var itemOption = preload("res://Utility/item_option.tscn")
@onready var lblTimer = get_node("%lblTimer") #alternate way of referencing a node
@onready var collectedWeapon = get_node("%CollectedWeapon")
@onready var collectedUpgrade = get_node("%CollectedUpgrade")
@onready var itemContainer = preload("res://Player/GUI_Player/item_container.tscn")
@onready var killedEnemyLbl = $GUILayer/GUI/KilledEnemy

@onready var deathPanel = $GUILayer/GUI/DeathPanel
@onready var lblResult = $GUILayer/GUI/DeathPanel/lbl_Result
@onready var snd_victory = $GUILayer/GUI/DeathPanel/snd_victory
@onready var snd_lose = $GUILayer/GUI/DeathPanel/snd_lose
#Signal
signal player_death

func _ready():	
	upgrade_character("icespear1")
	attack()
	set_expbar(experience, calculate_exp_cap())
	_on_hurt_box_hurt(0, 0, 0) #initialize player hp but with 0 angle, 0 knockback

func _physics_process(delta):
	movement()
	passed_time += delta
	change_time()
	
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
		iceSpearTimer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
			
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	
	if iceaxe_level > 0:
		spawn_iceaxe()
	
func _on_hurt_box_hurt(damage, _angle, _knockback): #trigger this signal after get hit
	if hurtSndTimer.is_stopped():
		catsnd.play()
		hurtSndTimer.start()
	hp -= clamp(damage-armor, 1.0, 999.0)
	healthBar.max_value = maxhp
	healthBar.value = hp
	
	#Disable Collision Shape and Time
	collision.call_deferred("set", "disabled", true)
	collision_disable_timer.start()
	
	if hp <= 0:
		death()
	
func _on_collision_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)

func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo + additional_attacks #baseammo is maximum ammo per one reload
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
	tornado_ammo += tornado_baseammo + additional_attacks #baseammo is maximum ammo per one reload
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
	
func spawn_iceaxe():	
	var get_iceaxe_total = iceaxeBase.get_child_count() #count a child in this node
	var calc_spawns = (iceaxe_ammo+additional_attacks) - get_iceaxe_total #we want minus we have)
	while calc_spawns > 0:
		var iceaxe_spawn = iceaxe.instantiate()
		iceaxe_spawn.global_position = global_position
		iceaxeBase.add_child(iceaxe_spawn)
		calc_spawns -= 1
	#Update Ice Axe
	var get_iceaxes = iceaxeBase.get_children() #array of iceaxe children
	for i in get_iceaxes:
		if i.has_method("update_iceaxe"): #update the level of iceaxe
			i.update_iceaxe() #upgrade each iceaxe in iceaxeBase node

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

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self
		
func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_exp(gem_exp)

func calculate_exp(gem_exp):
	var exp_required = calculate_exp_cap()
	collected_exp += gem_exp
	if experience + collected_exp >= exp_required:
		collected_exp -=  exp_required - experience
		exp_level += 1
		experience = 0
		exp_required = calculate_exp_cap()
		level_up()
	else:
		experience += collected_exp
		collected_exp = 0
		
	set_expbar(experience, exp_required)
	
func calculate_exp_cap():
	var exp_cap = exp_level
	if exp_level < 20:
		exp_cap = exp_level * 5
	elif exp_level < 40:
		exp_cap = 95 * (exp_level - 19)	*8
	else:
		exp_cap = 255 + (exp_level-39)*12
	return exp_cap

func set_expbar(set_value=1, set_max_value=100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
func level_up():
	snd_levelup.play()
	labelLevel.text = str("Level :",exp_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	#setting option choices on the screen
	var option = 0
	var optionsmax = 3
	while option < optionsmax:
		var optionChoice = itemOption.instantiate()
		optionChoice.item = get_random_item()
		upgradeOption.add_child(optionChoice)
		option += 1
	
	get_tree().paused = true
	
func upgrade_character(upgrade): #when player click any upgrade menu
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"iceaxe1":
			iceaxe_level = 1
			iceaxe_ammo = 1
		"iceaxe2":
			iceaxe_level = 2
		"iceaxe3":
			iceaxe_level = 3
		"iceaxe4":
			iceaxe_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"sock1","sock2","sock3","sock4":
			movement_speed += 20.0
		"snowglobe1","snowglobe2","snowglobe3","snowglobe4":
			spell_size += 0.10
		"mistletoe1","mistletoe2","mistletoe3","mistletoe4":
			spell_cooldown += 0.05
		"snowflake1","snowflake2":
			additional_attacks += 1
		"trumpet1":
			pickup_area.shape.radius = 9
		"trumpet2":
			pickup_area.shape.radius += 3.5
		"trumpet3":
			pickup_area.shape.radius += 7
		"trumpet4":
			pickup_area.shape.radius += 11
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
	
	adjust_gui_collection(upgrade)
	attack() #calling again, make sure that everything is updated	
	#removing option choices
	var option_child = upgradeOption.get_children()
	for i in option_child:
		i.queue_free()
		
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800, 50)
	get_tree().paused = false
	calculate_exp(0)
	
func get_random_item():
	var dblist = [] #dblist = eligible weapon/item list
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #if already owned, pass
			pass
		elif i in upgrade_options: #if alredy on the screen, pass
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #if equal food, pass
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #for every item that need to get level 1 first
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:	 #check prerequisite requirement in each item
				if not n in collected_upgrades: #if you haven't collected it yet then pass
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var random_item = dblist.pick_random()
		upgrade_options.append(random_item) #add to the menu
		return random_item
	else:
		return null

func change_time():
	var time = int(passed_time)
	var minute = int(time/60.0)
	var second = time % 60
	if minute < 10:
		minute = str(0, minute)
	if second < 10: #we do this method because it's only one digit (ex. we need 08 not 8
		second = str(0, second)
	lblTimer.text = str(minute,":",second)
	
func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"] #get the name of input upgrade
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"] #get the type of input upgrade
	if get_type != "item": #if it's not food
		var get_collected_displayname = [] #array of collected weapon/item names
		for i in collected_upgrades:
			get_collected_displayname.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displayname:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapon.add_child(new_item)
				"upgrade":
					collectedUpgrade.add_child(new_item)	

func death():
	deathPanel.visible = true
	emit_signal("player_death") #emit a signal before pausing
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel, "position", Vector2(220,50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	lblResult.text = "You Lose.."
	snd_lose.play()
				
func win_start():
	deathPanel.visible = true
	emit_signal("player_death") 
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel, "position", Vector2(220,50), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	lblResult.text = "You Win!"
	snd_victory.play()

func update_killing():
	killedEnemyLbl.text = str("Killed Enemy :",str(killed_enemy).pad_zeros(4))

func _on_button_menu_click_end(): #menu button clicked
	get_tree().paused = false
	var _level =  get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
	
func pickup_all_start():
	pickup_range = pickup_area.shape.radius
	pickup_area.shape.radius = 4000
	pickupAllTimer.start()
	
func _on_pickup_all_timer_timeout():
	pickup_area.shape.radius = pickup_range
