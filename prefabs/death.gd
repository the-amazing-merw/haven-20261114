@icon("res://editor/SkeletonPreview.svg")
extends Control



@onready var center := $VBoxContainer/Center
@onready var title := $VBoxContainer/Center/Title
@onready var sound := $Sound
@onready var timer := $Timer



func _ready() -> void:
	visibility_changed.connect(_on_visible)

func _on_visible() -> void:
	center.size_flags_stretch_ratio = 0.0
	title.add_theme_font_size_override("font_size", 0)
	title.add_theme_color_override("font_color", Color(1, 0, 0 ,0))
	
	
	var tween := create_tween()
	tween.bind_node(center)
	tween.tween_property(center, "size_flags_stretch_ratio", 1.0, 2).set_trans(Tween.TRANS_SINE)
	#tween.tween_callback(center.queue_free)
	
	sound.play()
	
	timer.start(2)
	timer.timeout.connect(func ():
		timer.stop()
		tween.stop()
		
		title.add_theme_font_size_override("font_size", 128)
		
		@warning_ignore("confusable_capture_reassignment")
		tween = create_tween()
		tween.tween_property(title, "theme_override_colors/font_color", Color.RED, 2).set_trans(Tween.TRANS_SINE)
		#tween.tween_method(_tween, Color(1, 0, 0 ,0), Color.RED, 2).set_trans(Tween.TRANS_SINE)
		#tween.tween_callback(title.queue_free)
	)

func _tween(color: Color) -> void:
	#title.remove_theme_color_override("font_color")
	title.add_theme_color_override("font_color", color)
