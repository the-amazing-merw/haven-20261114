@icon("res://editor/Weapon2D.svg")
@abstract
class_name Weapon2D extends RigidBody2D



## The function to determine the damage dealt to the enemy when in contact.
@abstract func enemy_damage(target: Enemy2D) -> int

## The function to determine the damage dealt to the player when in contact.
@abstract func player_damage(target: Player2D) -> int

## The function to determine whether to destroy the weapon.
@abstract func destroy_condition() -> bool

## Tell the weapon to be destroyed, after running custom clean-up code.
@abstract func destroy() -> void
