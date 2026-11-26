@icon("res://editor/CodeEdit.svg")
extends Control

#region Variables

@export var player: Player2D ## The player to debug.

@onready var health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/HealthValue/HealthSpin
@onready var max_health_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/MaxHealthSpin
@onready var speed_spin := $Resize/DebugPanel/Margin/Tabs/PlayerInfo/ScrollContainer/GridContainer/SpeedSpin

#endregion

#region Privates

func _ready() -> void:
	if player:
		max_health_spin.value = player.max_health
		health_spin.value = player.health
		speed_spin.value = player.speed
		
		player.health_changed.connect(_handle_player_change(health_spin))
		player.max_health_changed.connect(_handle_player_change(max_health_spin))
		player.speed_changed.connect(_handle_player_change(speed_spin))
		
		health_spin.value_changed.connect(_handle_spin_change("health"))
		max_health_spin.value_changed.connect(_handle_spin_change("max_health"))
		speed_spin.value_changed.connect(_handle_spin_change("speed"))
	
	$Resize/DebugPanel.folding_changed.connect(_handle_folding)

func _handle_player_change(spin: SpinBox):
	var curry = func (value):
		spin.value = value
	
	return curry

func _handle_spin_change(property: StringName):
	var curry = func (value):
		player.set(property, value)
	
	return curry

func _handle_folding(is_folded: bool) -> void:
	if is_folded:
		$Resize.dragger_visibility = SplitContainer.DraggerVisibility.DRAGGER_HIDDEN_COLLAPSED
	else:
		$Resize.dragger_visibility = SplitContainer.DraggerVisibility.DRAGGER_VISIBLE
	
	$Resize.dragging_enabled = !is_folded

#endregion
