extends Slider


@export var limiter: Range
@export var spin_counterpart: SpinBox


func _ready() -> void:
	if limiter == null: return
	
	limiter.value_changed.connect(func (new_value: float):
		var new: int = roundi(new_value)
		max_value = new_value
		tick_count = new + 1 if new <= 12 else 0
		
		if spin_counterpart:
			spin_counterpart.max_value = new_value
	)
