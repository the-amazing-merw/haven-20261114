extends Control

#region Variables

@export var connections: Array[Range]

#endregion

#region Privates

func _ready() -> void:
	for connection in connections:
		connection.value_changed.connect(_curry_connection_change(connection))

func _curry_connection_change(connection: Range) -> Callable:
	var _connection_changed = func (new_value: float) -> void:
		for c in connections:
			if c == connection: continue
			c.value = new_value
		
	return _connection_changed

#endregion
