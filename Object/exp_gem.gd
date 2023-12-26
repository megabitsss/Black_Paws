extends Area2D

@export var exp = 1

var sprite_candy = preload("res://Player/Attack/attack_sprites/candy.png")
var sprite_cookie = preload("res://Player/Attack/attack_sprites/cookie.png")
var sprite_gift = preload("res://Player/Attack/attack_sprites/giftBox.png")

var target = null
var speed = 0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var snd = $snd_collected

func _ready():
	if exp < 5:
		return
	
	
