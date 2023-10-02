extends Object
class_name SavedTileData

var position: Vector2i
var ID: int
var atlas_coords

func _init(pos: Vector2i, id: int, atlas_coordinates):
	position = pos
	ID = id
	atlas_coords = atlas_coordinates
