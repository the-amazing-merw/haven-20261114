extends Slider

#region Variables

@export var limiter: Range
@export var spin_counterpart: SpinBox

#endregion

#region Privates

func _ready() -> void:
	if not limiter: return
	
	limiter.value_changed.connect(_limiter_changed)

func _limiter_changed(new_value: float) -> void:
	var new: int = roundi(new_value)
	max_value = new_value
	tick_count = new + 1 if new <= 12 else 0
	
	if spin_counterpart:
		spin_counterpart.max_value = new_value

#endregion
