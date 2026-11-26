@icon("res://editor/Camera2D.svg")
class_name TrackingCamera2D extends Camera2D

## Tracks a [Node2D] with optional interpolation.
##
## Tracks a [Node2D] with optional interpolation inherited from [Camera2D].

#region Variables

@export var subject: Node2D ## The [Node2D] to track.

#endregion

#region Privates

func _process(_delta: float) -> void:
	if subject:
		position = subject.position

#endregion
