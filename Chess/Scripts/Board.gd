extends Sprite

class_name Board

const BOARD_DIMENSIONS = Vector2(8, 8)

enum PieceTypes {K,Q,B,N,R,P,k,q,b,n,r,p}
export var FEN : String

var current_piece = null
var current_piece_position = null
var select = false
var turn = "white"


func _ready():
	generate_tiles()
	default_setup()
	#print(PieceTypes$b8.get_child(2).piecetype)
	pass

func _process(delta):
	if select:
		current_piece.global_position = lerp(current_piece.global_position, get_global_mouse_position(), 30 * delta)
		

func generate_tiles() -> void:
	var file = ["a","b","c","d","e","f","g","h"]
	var rank = ["8","7","6","5","4","3","2","1"]
	
	for y in range (BOARD_DIMENSIONS.y):
		for x in range (BOARD_DIMENSIONS.x):
			var new_tile = load("res://Setup/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_pos(Vector2(x * 32 + 16, y * 32 + 16))
			new_tile.set_name(file[x] + rank[y])
	
func default_setup() -> void:
	FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
	set_board_from_FEN(FEN)

func set_board_from_FEN (FEN : String) -> void :
	var t = 0
	for i in range (FEN.length()):
		if FEN[i] == "/":
			continue
		if FEN[i].is_valid_integer():
			t += int(FEN[i])
			continue
		if FEN[i] == "K" or "Q" or "B" or "N" or "R" or "P" or "k" or "q" or "b" or "n" or "r" or "p":
			var new_piece = load("res://Setup/Piece.tscn").instance()
			if get_child(t) != null:
				get_child(t).add_child(new_piece)
				new_piece.set_name(FEN[i])
				new_piece.set_piece(PieceTypes.get(FEN[i]))
				t += 1
		if FEN[i] == " ":
			break

func _on_Piece_is_selected(selected_piece):
	if turn == "white" and  selected_piece.get_name().to_upper() == selected_piece.get_name():
		current_piece = selected_piece
		current_piece_position = current_piece.get_parent()
		select = true
	if turn == "black" and  selected_piece.get_name().to_lower() == selected_piece.get_name():
		current_piece = selected_piece
		current_piece_position = current_piece.get_parent()
		select = true

func _on_Piece_is_released(released_piece):
	if current_piece != null:
		var captured_piece = get_hover_piece()
		if captured_piece != null:
			captured_piece.is_captured()
		set_piece_position(current_piece)
		if current_piece_position != current_piece.get_parent():
			next_turn()
		select = false
		current_piece = null
		current_piece_position = null

func get_hover_tile() -> Node2D:
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.mouse_hover == true:
			return child
	return null
	
func get_hover_piece() -> Piece:
	var hover_piece = get_hover_tile().get_child(1)
	if current_piece == hover_piece:
		return null
	return hover_piece

func set_piece_position(Piece) -> void:
	Piece.position = Vector2(0,0)
	var new_tile = get_hover_tile()
	if new_tile != null:
		Piece.get_parent().remove_child(Piece)
		new_tile.add_child(Piece)

func next_turn() -> void:
	if turn == "white":
		turn = "black"
		return
	if turn == "black":
		turn = "white"
		return
