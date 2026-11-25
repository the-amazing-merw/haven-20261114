@icon("res://editor/CharacterBody3D.svg")
class_name Enemy2D extends RigidBody2D

## A navigating [RigidBody2D] with a radial [TextureProgressBar] for health.
##
## A navigating [RigidBody2D] with a radial [TextureProgressBar] for health.
## The enemy is editable, and has path-finding.

#region Signals

## Emits when [member enemy_health] is changed, alongside the new health.
signal health_changed(new_health: float)

## Emits when [member enemy_max_health] is changed, alongside the new maximum.
signal max_health_changed(new_max: float)

## Emits when [member enemy_speed] is changed, alongside the new speed.
signal speed_changed(new_speed: float)

## Emits when [member enemy_health] is zero or below.
signal died

## Emits when [member wander_target] has changed, alongside the new target.
signal wander_target_changed(new_target: Vector2)

## Emits when the player is spotted. 
signal player_spotted

#endregion

#region Properties

func _set_speed(new_speed):
	enemy_speed = new_speed
	navigation_agent.max_speed = new_speed
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

func _set_wander_target(new_target):
	wander_target = new_target
	wander_target_changed.emit(new_target)

#endregion

#region Variables

@export var info: EnemyInfo

## The current health of the enemy in [i]hp[/i].
@export_range(0, 6, 1, "or_greater", "suffix:hp") var enemy_health: int = 6: set = _set_health

var enemy_speed := 100.0
var enemy_max_health := 6
var enemy_knockback_mult := 10.0
var enemy_detection_radius := 512.0

var enemy_radial_enabled := true
var enemy_radial_radius := 30.0
var enemy_radial_min_damage := 1
var enemy_radial_max_damage := 1
var enemy_radial_damage_scaling := "Linear"

var wander_enabled := true
var wander_chance := 10.0
var wander_radius := 256.0
var wander_timeout := 3.0

@onready var navigation_agent := $Agent
@onready var ray := $Ray
@onready var hurt_area := $HurtArea
@onready var self_harm_area := $SelfHarmArea

var player: Player2D

var is_wandering: bool = false
var wander_target: Vector2: set = _set_wander_target
var wander_time: float = 0.0
var found_player: bool = false

#endregion

#region Privates

func _ready() -> void:
	if info:
		_setup_info()
		info.changed.connect(_setup_info)
	
	player = get_tree().current_scene.get_node(^"Player")
	
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	hurt_area.body_entered.connect(_damage_player)
	self_harm_area.body_entered.connect(_damage_self)
	player.died.connect(_on_player_death)
	died.connect(_on_self_death)

func _process(delta: float) -> void:
	if is_wandering:
		wander_time += delta
	else:
		wander_time = 0.0
	
	if (wander_target - position).length() < 10 or wander_time > wander_timeout:
		is_wandering = false
	
	ray.target_position = player.position - position
	if ray.is_colliding() or (ray.target_position).length() > enemy_detection_radius:
		if randf() <= wander_chance / 100 and !is_wandering:
			wander_target = position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * wander_radius
			is_wandering = true
			set_movement_target(wander_target)
		
		found_player = false
	else:
		if not found_player:
			found_player = true
			player_spotted.emit()
		
		is_wandering = true
		wander_time = 0.0
		wander_target = player.position
		
		set_movement_target(wander_target)

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

func _setup_info() -> void:
	enemy_speed = info.speed
	enemy_max_health = info.max_health
	enemy_knockback_mult = info.knockback_mult
	enemy_detection_radius = info.detection_radius
	
	enemy_radial_enabled = info.damage_radial_enabled
	enemy_radial_radius = info.damage_radial_radius
	enemy_radial_min_damage = info.damage_radial_min_damage
	enemy_radial_max_damage = info.damage_radial_max_damage
	enemy_radial_damage_scaling = info.damage_radial_scaling
	
	wander_enabled = info.wander_enabled
	wander_chance = info.wander_chance
	wander_radius = info.wander_radius
	wander_timeout = info.wander_timeout

#endregion

#region Helpers

## Gets the alpha from a linearly interpolated number.
func get_alpha(x: float, a: float, b: float) -> float:
	return (x - a) / (b - a)

## Sets the destination for path-finding.
func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)

#endregion

#region Extras

func _damage_player(_other_body) -> void:
	var damage: float = 0.0
	
	var alpha: float = clampf(get_alpha((player.position - position).length(), enemy_radial_radius, 30.0), 0.0, 1.0)
	
	if enemy_radial_damage_scaling == "Linear":
		damage = lerpf(enemy_radial_min_damage, enemy_radial_max_damage, alpha)
	elif enemy_radial_damage_scaling == "Exponential":
		damage = lerpf(enemy_radial_min_damage, enemy_radial_max_damage, alpha ** 3.0)
	elif enemy_radial_damage_scaling == "Logarithmic":
		damage = lerpf(enemy_radial_min_damage, enemy_radial_max_damage, alpha ** 0.33)
	
	player.health -= roundi(damage)
	player.velocity += linear_velocity * enemy_knockback_mult
	player.move_and_slide()

func _damage_self(other_body: PhysicsBody2D) -> void:
	if other_body is Weapon2D:
		var weapon: Weapon2D = other_body
		var damage = weapon.enemy_damage(self)
		
		enemy_health -= damage

func _on_player_death() -> void:
	var tween = create_tween()
	
	tween.bind_node(self)
	tween.tween_property(self, "enemy_speed", 0.0, 2.0).set_trans(Tween.TRANS_SINE)

func _on_self_death() -> void:
	queue_free()

#endregion
