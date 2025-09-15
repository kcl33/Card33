extends Control

@export var columns: int = 12
@export var gutter: int = 16

func layout_child(node: Control, col_start: int, col_span: int, top: int, height: int):
	var col_w = (size.x - (columns - 1) * gutter) / columns
	var x = (col_start - 1) * (col_w + gutter)
	node.position = Vector2(x, top)
	node.size = Vector2(col_w * col_span + gutter * (col_span - 1), height)


