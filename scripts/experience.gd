extends Control

@onready var bar: ProgressBar = $ExperienceBar

var player: Player2D

func _ready() -> void:
	player = get_tree().current_scene.get_node(^"Player")
	player.add_xp.connect(_add_xp)

func _add_xp(_xp) -> void:
	bar.value = player.xp_for_this_level
	bar.max_value = player.get_level_cap(player.xp_level)
