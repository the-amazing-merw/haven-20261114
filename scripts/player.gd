## A controllable [CharacterBody2D] with a radial [TextureProgressBar] for health.
##
## A controllable [CharacterBody2D] with a radial [TextureProgressBar] for health.
## Speed is measured in [i]milliunits[/i] and a default health and max health of [code]6 hp[/code].

@icon("res://editor/CharacterBody2D.svg")
class_name Player2D extends CharacterBody2D



## Emits when [member health] is changed. Sends the new health as [param new_health].
signal health_changed(new_health: float)

## Emits when [member max_health] is changed. Sends the new health as [param new_max].
signal max_health_changed(new_max: float)

## Emits when [member speed] is changed. Sends the new speed as [param new_speed].
signal speed_changed(new_speed: float)

## Emits when [member health] is zero or below.
signal died



## The speed of the player in [i]milliunits[/i].
@export_range(-250, 250, 25, "or_greater", "or_less", "prefer_slider", "suffix:mu") var speed: float = 100.0: set = _set_speed

## The maximum health the player may have in [i]hp[/i].
@export_range(1, 6, 1, "or_greater", "suffix:hp") var max_health: int = 6: set = _set_max_health

## The current health the player in [i]hp[/i].
@export_range(0, 6, 1, "or_greater", "suffix:hp") var health: int = 6: set = _set_health



func _set_speed(new_speed):
	speed = new_speed
	speed_changed.emit(new_speed)

func _set_max_health(new_max):
	max_health = new_max
	health = clampi(health, 0, new_max)
	$TextureProgressBar.max_value = new_max
	max_health_changed.emit(new_max)

func _set_health(new_value):
	health = clampi(new_value, 0, max_health)
	$TextureProgressBar.value = health
	health_changed.emit(new_value)
	
	if new_value <= 0:
		died.emit()



func _ready() -> void:
	died.connect(_on_death)

func _physics_process(_delta: float) -> void:
	# Input
	var inputVector := Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	var localVelocity := inputVector.normalized() * speed
	
	# Math
	velocity += localVelocity * 0.8
	velocity *= 0.8
	
	move_and_slide()

func _on_death() -> void:
	print("We died.")
