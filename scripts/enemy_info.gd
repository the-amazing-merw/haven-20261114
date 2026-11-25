@icon("res://editor/EnemyInfo.svg")
class_name EnemyInfo extends Resource

## The method this enemy uses to move.
## [br][br]
## [b]Walking:[/b] The enemy walks, using path-finding to get to its destination.
## [br][br]
## [b]Flying:[/b] The enemy is able to bypass walls entirely, and detection is determined only by the radius.
## Flies directly toward the target.
## [br][br]
## [b]Drone:[/b] Like [code]flying[/code], but overshoots the target.
## [br][br]
## [b]Teleportation:[/b] The enemy teleports to its destination. Ignores [member wander_timeout].
@export_enum("Walking", "Flying", "Drone", "Teleportation") var movement_type: String = "Walking"

## The speed multiplier at which the enemy moves, in [i]milliunits[/i].
@export_range(50.0, 250.0, 1.0, "hide_control", "or_greater", "or_less", "suffix:mu") var speed: float = 100.0

## The maximum and initial health of the enemy.
@export_range(1, 6, 1, "prefer_slider", "or_greater", "suffix:hp") var max_health: int = 6

## The knockback multiplier of the enemy.
@export_range(10.0, 25.0, 0.1, "hide_control", "or_greater", "or_less") var knockback_mult: float = 10.0

## The radius wherein the enemy may notice you, in pixels.
## Set to `0` to remove the limit.
@export_range(0.0, 2048.0, 1.0, "hide_control", "or_greater", "suffix:px") var detection_radius: float = 2048.0

## The XP awarded to the player when this enemy dies.
@export_range(0, 1000, 1, "hide_control", "or_greater", "suffix:xp") var experience_value: int = 1


@export_group("Radial Damage", "damage_radial")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var damage_radial_enabled: bool = true

## The distance at which the player is damaged by the enemy.
@export_range(30.0, 128.0, 0.1, "hide_control", "or_greater", "suffix:px") var damage_radial_radius: float = 30.0

## The minimum damage dealt by entering the radius (distance > 30)
@export_range(0, 6, 1, "hide_control", "or_greater", "suffix:hp") var damage_radial_min_damage: int = 1

## The maximum damage dealt by entering the radius (distance ≤ 30)
@export_range(0, 6, 1, "hide_control", "or_greater", "suffix:hp") var damage_radial_max_damage: int = 1

## Determines the scaling of damage.
@export_enum("Linear", "Exponential", "Logarithmic") var damage_radial_scaling: String = "Linear"

@export_group("Boss", "boss")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var boss_enabled: bool = false

## Determines the number of upgrades unlocked by defeating the boss
@export var boss_rewarded_upgrades: int = 3

## Should a bossbar be displayed?
@export var boss_bossbar: bool = true



@export_group("Wandering", "wander")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var wander_enabled: bool = false

## The chance that the enemy will wander, per frame.
@export_range(0.0, 100.0, 1.0, "prefer_slider", "suffix:%") var wander_chance: float = 1.0

## The maximum radius that the enemy may wander.
@export_range(0.0, 2048.0, 1.0, "hide_control", "or_greater", "suffix:px") var wander_radius: float = 256.0

## The maximum time an enemy may wander for.
@export_range(0.0, 10.0, 0.1, "hide_control", "or_greater", "suffix:s") var wander_timeout: float = 3.0
