@icon("res://editor/Weapon2D.svg")
@abstract
class_name Weapon2D extends RigidBody2D

## A base class for all weapons.
##
## A base class for all weapons.
## Contains abstract functions for determining damage to targets, conditions for events, and other ubiquitous functions / properties.

#region Implementations

@abstract func enemy_damage(target: Enemy2D) -> int ## The function to determine the damage dealt to the enemy when in contact.
@abstract func player_damage(target: Player2D) -> int ## The function to determine the damage dealt to the player when in contact.
@abstract func destroy_condition() -> bool ## The function to determine whether to destroy the weapon.
@abstract func destroy() -> void ## Tell the weapon to be destroyed, after running custom clean-up code.

#endregion
