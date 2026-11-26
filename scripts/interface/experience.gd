extends Control

#region Variables

@onready var bar: ProgressBar = $ExperienceBar

var player: Player2D

#endregion

#region Privates

func _ready() -> void:
	player = get_tree().current_scene.get_node(^"Player")
	
	assert(player, "[EXPERIENCE] Player cannot be found in %s/Player… Aborting!" % get_tree().current_scene.get_path())
	
	player.add_xp.connect(_add_xp)

func _add_xp(_xp) -> void:
	bar.value = player.xp_for_this_level
	bar.max_value = player.get_level_cap(player.xp_level)

#endregion
