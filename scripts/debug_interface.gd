@icon("res://editor/CodeEdit.svg")
extends Control


@export var player: Player2D

@onready var health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/HealthValue/HealthSpin
@onready var max_health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/MaxHealthSpin
@onready var speed_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/SpeedSpin


func handle_player_change(spin: SpinBox):
	var curry = func (value):
		spin.value = value
	
	return curry

func handle_spin_change(property: StringName):
	var curry = func (value):
		player.set(property, value)
	
	return curry

func _ready() -> void:
	if player:
		player.health_changed.connect(handle_player_change(health_spin))
		player.max_health_changed.connect(handle_player_change(max_health_spin))
		player.speed_changed.connect(handle_player_change(speed_spin))
		
		health_spin.value_changed.connect(handle_spin_change("health"))
		max_health_spin.value_changed.connect(handle_spin_change("max_health"))
		speed_spin.value_changed.connect(handle_spin_change("speed"))
	
	$Resize/DebugPanel.folding_changed.connect(func (is_folded):
		$Resize.dragger_visibility = SplitContainer.DraggerVisibility.DRAGGER_HIDDEN_COLLAPSED if is_folded else SplitContainer.DraggerVisibility.DRAGGER_VISIBLE
		$Resize.dragging_enabled = !is_folded
	)
