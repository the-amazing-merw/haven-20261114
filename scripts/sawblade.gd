@icon("res://editor/Sawblade2D.svg")
class_name Sawblade2D extends Weapon2D



var player: Player2D

var bounces: int = 0

func enemy_damage(_target: Enemy2D) -> int:
	return 1 + (bounces if player.upgrade_sawblade_bouncy_damage else 0)

func player_damage(_target: Player2D) -> int:
	return 0

func destroy_condition() -> bool:
	return bounces > player.upgrade_sawblade_bounces

func destroy() -> void:
	queue_free()

func _ready() -> void:
	player = get_tree().current_scene.get_node(^"Player")
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	$Sawblade.rotation_degrees += 3600.0 * delta

func _on_body_entered(body: Node):
	if body.is_class("CollisionObject2D"):
		var b: CollisionObject2D = body
		
		if b.collision_layer == 1:
			bounces += 1
			
			if destroy_condition():
				destroy()
