extends Polygon2D



var sawblade := preload("res://prefabs/weapons/sawblade.tscn")
@onready var weapons_folder: Node = $"/root/DemoLevel/Weapons"

func _input(event: InputEvent) -> void:
	var mouse = get_global_mouse_position()
	
	if event.is_action_pressed("weapon_sawblade"):
		var weapon: RigidBody2D = sawblade.instantiate()
		weapons_folder.add_child(weapon)
		weapon.position = $"..".position
		weapon.linear_velocity = Vector2(cos(rotation), sin(rotation)) * 500


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
