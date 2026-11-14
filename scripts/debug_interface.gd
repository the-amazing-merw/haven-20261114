@icon("res://editor/CodeEdit.svg")
extends Control


@export var player: Player2D

@onready var health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/HealthValue/HealthSpin
@onready var max_health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/MaxHealthSpin


func _ready() -> void:
	player.health_changed.connect(func (new_health): health_spin.value = new_health)
	player.max_health_changed.connect(func (new_max): max_health_spin.value = new_max)
	health_spin.value_changed.connect(func (new_health): player.health = new_health)
	max_health_spin.value_changed.connect(func (new_max): player.max_health = new_max)
