extends Node2D

class_name BoardTile

export var haspiece : bool = false
var mouse_hover = false

func _process(delta):
#	if mouse_hover:
#		print(get_name())
		pass

func get_tile_pos() -> Vector2:
	return position

func set_tile_pos(new_position: Vector2) -> void:
	position = new_position

func _on_Area2D_mouse_entered():
	mouse_hover = true

func _on_Area2D_mouse_exited():
	mouse_hover = false

func get_piece():
	return Piece
