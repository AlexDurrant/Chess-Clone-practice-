extends Sprite

class_name Piece
onready var Board = get_node("/root/MainBoard")
export var piecetype : int 
#piecetype = board.PieceTypes.K

var released = false

signal is_captured(Piece)
signal is_selected(Piece)
signal is_released(Piece)


func is_captured() -> void:
	emit_signal("is_captured")
	queue_free()

func set_piece(_piece) -> void:
	piecetype = _piece
	var piecename = get_piece_name()
	if piecename == piecename.to_lower():
		piecename = str("_" + piecename)
	texture = load("res://Sprites/Pieces/" + piecename + ".tres")
	connect("is_selected", Board, "_on_Piece_is_selected")
	connect("is_released", Board, "_on_Piece_is_released")


func get_piece_name() -> String:
	return Board.PieceTypes.keys()[piecetype]

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		emit_signal("is_selected", self)
	if Input.is_action_just_released("click"):
		emit_signal("is_released", self)
	


