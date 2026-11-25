@icon("res://editor/EnemyInfo.svg")
class_name EnemyInfo extends Resource

@export_enum("walking", "flying", "drone", "teleportation") var movement_type: String = "walking"
@export_range(1, 6, 1, "prefer_slider", "or_greater") var health: int = 6
@export var is_boss: bool = false

@export_group("Wandering", "wander")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var wander_enabled: bool = false
