@icon("res://editor/SkeletonPreview.svg")
extends Control

#region Variables

@onready var center := $VBoxContainer/Center
@onready var title := $VBoxContainer/Center/Title
@onready var sound := $Sound
@onready var timer := $Timer

#endregion

#region Privates

func _ready() -> void:
	visibility_changed.connect(_on_visible)

func _on_visible() -> void:
	# Shrink the center.
	center.size_flags_stretch_ratio = 0.0
	
	# Make the title small and invisible.
	title.add_theme_font_size_override("font_size", 0)
	title.add_theme_color_override("font_color", Color(1, 0, 0 ,0))
	
	# Tween the center to its regular size.
	var tween := create_tween()
	tween.bind_node(center)
	tween.tween_property(center, "size_flags_stretch_ratio", 1.0, 2).set_trans(Tween.TRANS_SINE)
	
	sound.play()
	
	# After two seconds, resize and recolor the title.
	timer.start(2)
	timer.timeout.connect(_tween_title)

func _tween_title() -> void:
	timer.stop()
	
	title.add_theme_font_size_override("font_size", 128)
	
	@warning_ignore("confusable_capture_reassignment") # We are explicitly overriding it.
	var tween = create_tween()
	tween.tween_property(title, "theme_override_colors/font_color", Color.RED, 2).set_trans(Tween.TRANS_SINE)

func _tween(color: Color) -> void:
	#title.remove_theme_color_override("font_color")
	title.add_theme_color_override("font_color", color)

#endregion
