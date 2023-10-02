extends Node2D
class_name ObstacleManager

@export var tilemap: TileMap

var saved_tiles_array = []

##set tile method that takes in the position and what the tile was
#save that to an array of tile datas
func set_tile(position: Vector2i, new_tile_ID: int, old_tile_ID: int):
	tilemap.set_cell(0, position, new_tile_ID, Vector2i(0,0))
	
	var savedtile = SavedTileData.new(position, old_tile_ID)
	saved_tiles_array.push_back(savedtile)

##restoresavedtile method that takes in position and returns the tile to its original form
