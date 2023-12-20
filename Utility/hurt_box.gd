extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0 #cooldown = 0, hitonce=1,disablehitbox=2

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_once_array = []

signal hurt(damage, angle, knockback) #declar a "custom" signal with damage parameter

func _on_area_entered(area):
	if area.is_in_group("attack"): ###
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start() #countdown 0.5 sec
				1: #HitOnce, enemy get penatrated
					if hit_once_array.has(area) == false:
						hit_once_array.append(area) #add again, so we can ignore for future hits
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")): #just check this condition to prevent conflicts
								area.connect("remove_from_array", Callable(self, "remove_from_list")) #เป็นการเชื่อมทิ้งไว้เฉยๆ ยังไม่ได้เรียก เวลาเรียกใช้งาน จะเรียกใน node icespear
					else:
						return #just end this function, we won't hit them again 2nd time
				2: #DisableHitBox
					if area.has_method("temp_disable"): #disable hitbox instead of hurtbox
						area.temp_disable()
						
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			
			emit_signal("hurt", damage, angle, knockback) #calling "that" signal
			if area.has_method("enemy_hit"): #project hp
				area.enemy_hit(1)


func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
