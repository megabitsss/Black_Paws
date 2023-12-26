extends Node

#Database

const ICON_PATH = "res://GUI/Items/"
const WEAPON_PATH = "res://Player/Attack/attack_sprites/"
const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Shard",
		"detail": "A shard of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Shard",
		"detail": "An addition Ice Spear is thrown",
		"level": "Level: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Shard",
		"detail": "Ice Shards now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Shard",
		"detail": "An additional 2 Ice Shards are thrown",
		"level": "Level: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon"
	},
	"iceaxe1": {
		"icon": WEAPON_PATH + "iceAxeAttack.png",
		"displayname": "Ice Axe",
		"detail": "An ice axe that strikes through enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"iceaxe2": {
		"icon": WEAPON_PATH + "iceAxeAttack.png",
		"displayname": "Ice Axe",
		"detail": "The ice axe will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["iceaxe1"],
		"type": "weapon"
	},
	"iceaxe3": {
		"icon": WEAPON_PATH + "iceAxeAttack.png",
		"displayname": "Ice Axe",
		"detail": "The iceaxe will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["iceaxe2"],
		"type": "weapon"
	},
	"iceaxe4": {
		"icon": WEAPON_PATH + "iceAxeAttack.png",
		"displayname": "Ice Axe",
		"detail": "The iceaxe now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["iceaxe3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "starIcon.png",
		"displayname": "Star Tornado",
		"detail": "A tornado full of stars is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "starIcon.png",
		"displayname": "Star Tornado",
		"detail": "An additional star tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "starIcon.png",
		"displayname": "Star Tornado",
		"detail": "The  Star Tornado cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "starIcon.png",
		"displayname": "Star Tornado",
		"detail": "An additional star tornado is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "gift2.png",
		"displayname": "Present",
		"detail": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "gift2.png",
		"displayname": "Present",
		"detail": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "gift2.png",
		"displayname": "Present",
		"detail": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "gift2.png",
		"displayname": "Present",
		"detail": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"sock1": {
		"icon": ICON_PATH + "sock.png",
		"displayname": "Sock",
		"detail": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"sock2": {
		"icon": ICON_PATH +  "sock.png",
		"displayname": "Sock",
		"detail": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"sock3": {
		"icon": ICON_PATH +  "sock.png",
		"displayname": "Sock",
		"detail": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"sock4": {
		"icon": ICON_PATH +  "sock.png",
		"displayname": "Sock",
		"detail": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"snowglobe1": {
		"icon": ICON_PATH + "snowGlobe.png",
		"displayname": "Snow Globe",
		"detail": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"snowglobe2": {
		"icon": ICON_PATH + "snowGlobe.png",
		"displayname": "Snow Globe",
		"detail": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["snowglobe1"],
		"type": "upgrade"
	},
	"snowglobe3": {
		"icon": ICON_PATH + "snowGlobe.png",
		"displayname": "Snow Globe",
		"detail": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["snowglobe2"],
		"type": "upgrade"
	},
	"snowglobe4": {
		"icon": ICON_PATH + "snowGlobe.png",
		"displayname": "Snow Globe",
		"detail": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["snowglobe3"],
		"type": "upgrade"
	},
	"mistletoe": {
		"icon": ICON_PATH + "mistletoe.png",
		"displayname": "Mistletoe",
		"detail": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"mistletoe2": {
		"icon": ICON_PATH + "mistletoe.png",
		"displayname": "Mistletoe",
		"detail": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["mistletoe1"],
		"type": "upgrade"
	},
	"mistletoe3": {
		"icon": ICON_PATH + "mistletoe.png",
		"displayname": "Mistletoe",
		"detail": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["mistletoe2"],
		"type": "upgrade"
	},
	"mistletoe4": {
		"icon": ICON_PATH + "mistletoe.png",
		"displayname": "Mistletoe",
		"detail": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["mistletoe3"],
		"type": "upgrade"
	},
	"snowflake1": {
		"icon": ICON_PATH + "snowflake.png",
		"displayname": "Snwoflake",
		"detail": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"snowflake2": {
		"icon": ICON_PATH + "snowflake.png",
		"displayname": "Snowflake",
		"detail": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["snowflake1"],
		"type": "upgrade"
	},
	"trumpet1": {
		"icon": ICON_PATH + "trumpet.png",
		"displayname": "Trumpet",
		"detail": "Your picking range is increased.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"trumpet2": {
		"icon": ICON_PATH + "trumpet.png",
		"displayname": "Trumpet",
		"detail": "Your picking range is increased.",
		"level": "Level: 2",
		"prerequisite": ["trumpet1"],
		"type": "upgrade"
	},
	"trumpet3": {
		"icon": ICON_PATH + "trumpet.png",
		"displayname": "Trumpet",
		"detail": "Your picking range is increased.",
		"level": "Level: 3",
		"prerequisite": ["trumpet2"],
		"type": "upgrade"
	},
	"trumpet4": {
		"icon": ICON_PATH + "trumpet.png",
		"displayname": "Trumpet",
		"detail": "Your picking range is increased.",
		"level": "Level: 4",
		"prerequisite": ["trumpet3"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "candy_cane.png",
		"displayname": "Food",
		"detail": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
