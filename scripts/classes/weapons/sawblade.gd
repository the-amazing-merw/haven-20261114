@icon("res://editor/Sawblade2D.svg")
class_name Sawblade2D extends Weapon2D

## A simple Sawblade with several upgrades.
##
## A simple Sawblade with several upgrades. One of the most basic weapons.
## This weapon bounces off walls and damages enemies accordingly.
## All upgrades are stored in [Player2D]. Without one directly within the current scene, the code will throw an error.

#region Variables

const SAFE_DURATION: float = 0.05

var player: Player2D
var bounces: int = 0
var initial_speed: float = 0.0
var lifetime: float = 0.0

#endregion

#region Implementations

func enemy_damage(_target: Enemy2D) -> int:
	return 1 + (bounces if player.upgrade_sawblade_bouncy_damage else 0)

func player_damage(_target: Player2D) -> int:
	# An example of a legit implementation, without the damage.
	
	if lifetime <= SAFE_DURATION:
		return 0
	
	return 0

func destroy_condition() -> bool:
	return bounces > player.upgrade_sawblade_bounces

func destroy() -> void:
	queue_free()

#endregion

#region Privates

func _ready() -> void:
	player = get_tree().current_scene.get_node(^"Player")
	
	assert(player, "[SAWBLADE] Player cannot be found in %s/Player… Aborting!" % get_tree().current_scene.get_path())
	
	body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	$Sawblade.rotation_degrees += 3600.0 * delta
	lifetime += delta

func _physics_process(_delta: float) -> void:
	if linear_velocity != Vector2() and initial_speed == 0.0:
		initial_speed = linear_velocity.length()
	
	linear_velocity = linear_velocity.normalized() * initial_speed

func _on_body_entered(body: Node):
	if body.is_class("CollisionObject2D"):
		var b: CollisionObject2D = body
		
		if b.collision_layer == 1:
			bounces += 1
			
			if destroy_condition():
				destroy()

#endregion
