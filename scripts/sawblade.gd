class_name Sawblade2D extends Weapon2D



@onready var player: Player2D

var bounces: int = 0

func damage(_target: Enemy2D) -> int:
	return 1 + (bounces if player.upgrade_sawblade_bouncy_damage else 0)

func _ready() -> void:
	player = get_tree().current_scene.get_node(^"Player")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.is_class("CollisionObject2D"):
		var b: CollisionObject2D = body
		
		if b.collision_layer == 1:
			bounces += 1
			
			if bounces > player.upgrade_sawblade_bounces:
				queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	angular_velocity = 50.0
