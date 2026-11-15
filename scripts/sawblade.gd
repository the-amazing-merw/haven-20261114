extends RigidBody2D



var awake_time: float = 0.0

#func _ready() -> void:
	#body_entered.connect(_on_body_entered)
#
#func _on_body_entered(body: Node):
	#if body.collision_layer

func _process(delta: float) -> void:
	awake_time += delta
	if awake_time >= 10.0:
		queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	angular_velocity = 50.0
