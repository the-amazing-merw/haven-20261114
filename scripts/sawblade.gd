@icon("res://editor/Sawblade2D.svg")
class_name Sawblade2D extends Weapon2D



var player: Player2D
var bounces: int = 0
var initial_speed: float = 0.0

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
	#initial_speed = linear_velocity.length()

func _physics_process(_delta: float) -> void:
	if linear_velocity != Vector2() and initial_speed == 0.0:
		initial_speed = linear_velocity.length()
	
	linear_velocity = linear_velocity.normalized() * initial_speed

func _process(delta: float) -> void:
	$Sawblade.rotation_degrees += 3600.0 * delta

func _on_body_entered(body: Node):
	if body.is_class("CollisionObject2D"):
		var b: CollisionObject2D = body
		
		if b.collision_layer == 1:
			bounces += 1
			
			if destroy_condition():
				destroy()
