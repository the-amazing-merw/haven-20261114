## A controlled [CharacterBody2D] with a radial [TextureProgressBar] for health.
##
## A controlled [CharacterBody2D] with a radial [TextureProgressBar] for health.
## Speed is measured in [i]milliunits[/i] and a default health and max health of [code]6 hp[/code].
## The enemy is editable, and has path-finding.

@icon("res://editor/CharacterBody3D.svg")
class_name Enemy2D extends RigidBody2D



## Emits when [member enemy_health] is changed. Sends the new health as [param new_health].
signal health_changed(new_health: float)

## Emits when [member enemy_max_health] is changed. Sends the new health as [param new_max].
signal max_health_changed(new_max: float)

## Emits when [member enemy_speed] is changed. Sends the new speed as [param new_speed].
signal speed_changed(new_speed: float)

## Emits when [member enemy_health] is zero or below.
signal died



## The player to target.
@export var player: Player2D



@export_group("Enemy", "enemy")

## The speed of the player in [i]milliunits[/i].
@export_range(-250, 250, 25, "or_greater", "or_less", "prefer_slider", "suffix:mu") var enemy_speed: float = 100.0: set = _set_speed

## The maximum health the player may have in [i]hp[/i].
@export_range(1, 6, 1, "or_greater", "suffix:hp") var enemy_max_health: int = 6: set = _set_max_health

## The current health the player in [i]hp[/i].
@export_range(0, 6, 1, "or_greater", "suffix:hp") var enemy_health: int = 6: set = _set_health

## The damage dealt by the enemy when it comes in contact with the player.
@export_range(0, 6, 1, "or_greater", "suffix:hp") var enemy_damage: int = 1

## The knockback multiplier used to prevent issues between the enemy and player.
@export_range(1.0, 5.0, 1.0, "or_greater", "suffix:x") var enemy_knockback_mult: float = 10.0

## The maximum distance the enemy can see the player from.
@export_range(25.6, 256.0, 25.6, "hide_control", "or_greater", "suffix:px") var enemy_detection_radius: float = 256.0



@export_group("Wandering", "wandering")

## The chance that this enemy will wander.
@export_range(0.0, 100.0, 1.0, "prefer_slider", "suffix:%") var wandering_chance: float = 10.0

## The maximum radius this enemy may wander.
@export_range(25.6, 256.0, 25.6, "hide_control", "or_greater", "suffix:px") var wandering_radius: float = 256.0

## The maximum time this enemy can wander.
@export_range(0.0, 10.0, 1.0, "hide_control", "or_greater", "suffix:s") var wandering_timeout: float = 3.0



func _set_speed(new_speed):
	enemy_speed = new_speed
	speed_changed.emit(new_speed)

func _set_max_health(new_max):
	enemy_max_health = new_max
	enemy_health = clampi(enemy_health, 0, new_max)
	$TextureProgressBar.max_value = new_max
	max_health_changed.emit(new_max)

func _set_health(new_value):
	enemy_health = clampi(new_value, 0, enemy_max_health)
	$TextureProgressBar.value = new_value
	health_changed.emit(new_value)
	if new_value <= 0:
		died.emit()



@onready var navigation_agent := $Agent
@onready var ray := $Ray
@onready var hurt_area := $HurtArea
@onready var self_harm_area := $SelfHarmArea

var is_wandering: bool
var wander_target: Vector2
var wander_time: float



func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	speed_changed.connect(func (new_speed): navigation_agent.max_speed = new_speed)
	hurt_area.body_entered.connect(_damage_player)
	self_harm_area.body_entered.connect(_damage_self)
	player.died.connect(_on_player_death)
	died.connect(_on_self_death)

func _process(delta: float) -> void:
	if is_wandering:
		wander_time += delta
	else:
		wander_time = 0.0
	
	if magnitude(wander_target - position) < 10 or wander_time > wandering_timeout:
		is_wandering = false
	
	ray.target_position = player.position - position
	if ray.is_colliding() or magnitude(ray.target_position) > enemy_detection_radius:
		if randf() <= wandering_chance / 100 and !is_wandering:
			wander_target = position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * wandering_radius
			is_wandering = true
			set_movement_target(wander_target)
	else:
		is_wandering = true
		wander_time = 0.0
		wander_target = player.position
		set_movement_target(wander_target)

func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

func magnitude(vector: Vector2) -> float:
	return sqrt(vector.x ** 2 + vector.y ** 2)

func _physics_process(_delta: float):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0: return
	if navigation_agent.is_navigation_finished(): return
	
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * enemy_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	linear_velocity = safe_velocity

func _damage_player(_other_body) -> void:
	player.health -= enemy_damage
	player.velocity += linear_velocity * enemy_knockback_mult
	player.move_and_slide()

func _damage_self(_other_body) -> void:
	enemy_health -= 1

func _on_player_death() -> void:
	var tween = create_tween()
	tween.bind_node(self)
	tween.tween_property(self, "enemy_speed", 0.0, 2.0).set_trans(Tween.TRANS_SINE)

func _on_self_death() -> void:
	queue_free()
