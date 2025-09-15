extends Node
class_name UIMotion

@export var theme_profile: Resource

func show_with_motion(target: Node, delay: float = 0.0) -> void:
	if not is_instance_valid(target):
		return
	var t := create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.set_parallel(false)
	t.set_loops(1)
	t.set_delay(delay)

	if target is CanvasItem:
		target.visible = true
		var start_scale := Vector2(0.86, 0.86)
		var end_scale := Vector2.ONE
		target.scale = start_scale
		t.target_property(target, "scale", end_scale, 0.32)
		# 轻微旋转以体现朋克倾斜
		var start_rot := deg_to_rad( (theme_profile.reveal_skew_degrees if theme_profile else 10.0) )
		target.rotation = start_rot
		t.target_property(target, "rotation", 0.0, 0.32)

func hide_with_motion(target: Node, delay: float = 0.0) -> void:
	if not is_instance_valid(target):
		return
	var t := create_tween()
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_IN)
	t.set_delay(delay)
	if target is CanvasItem:
		t.target_property(target, "scale", Vector2(0.8, 0.8), 0.22)
		t.target_property(target, "modulate:a", 0.0, 0.22)
		t.tween_callback(Callable(target, "hide"))

func title_blast(title_node: Node) -> void:
	# 标题外抛->中心弹入
	if not (title_node is CanvasItem):
		return
	var ci := title_node as CanvasItem
	var t := create_tween()
	# 外抛
	var original_pos: Vector2 = Vector2.ZERO
	if ci is Control:
		original_pos = (ci as Control).position
	elif ci is Node2D:
		original_pos = (ci as Node2D).position
	var off := Vector2(0, -get_viewport().size.y * 0.6)
	var scale0 := Vector2.ONE
	var scale_peak := Vector2( (theme_profile.reveal_scale_peak if theme_profile else 1.12), (theme_profile.reveal_scale_peak if theme_profile else 1.12) )
	ci.scale = scale0
	t.tween_property(ci, "position", original_pos + off, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# 弹回并放大
	t.tween_property(ci, "position", original_pos, 0.26).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(ci, "scale", scale_peak, 0.22)
	t.tween_property(ci, "scale", Vector2.ONE, 0.18)
