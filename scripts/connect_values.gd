extends Control


@export var connections: Array[Range]


func _ready() -> void:
	for connection in connections:
		connection.value_changed.connect(func (value: float):
			for c in connections:
				if c == connection: continue
				c.value = value
		)
