extends Node2D
class_name ObstacleManager

@export var tilemap: TileMap
@export var interactableArea: PackedScene

var saved_tiles_array = []
var carrying_obstacle = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") && carrying_obstacle:
		if carrying_obstacle:
			var clicked_tile = tilemap.local_to_map(get_local_mouse_position())
			set_and_save_tile(clicked_tile, 3, tilemap.get_cell_source_id(0, clicked_tile))
			carrying_obstacle = false
	
##set tile method that takes in the position and what the tile was
#save that to an array of tile datas
func set_and_save_tile(pos: Vector2i, new_tile_ID: int, old_tile_ID: int):
	set_tile(pos, new_tile_ID)
	
	var savedtile = SavedTileData.new(pos, old_tile_ID)
	saved_tiles_array.push_back(savedtile)
	
	var new_area = interactableArea.instantiate() as InteractableArea
	new_area.obstacle_manager = self
	new_area.global_position = tilemap.map_to_local(pos)
	call_deferred("add_child", new_area)
	
func set_tile(pos: Vector2i, new_tile_ID: int):
	tilemap.set_cell(0, pos, new_tile_ID, Vector2i(0,0))

##restoresavedtile method that takes in position and returns the tile to its original form
func interact_with_tile(pos: Vector2, area: InteractableArea):
	if carrying_obstacle:
		return 
	else:
		carrying_obstacle = true
	
	##set tile at pos to old tile
	var cellposition = tilemap.local_to_map(pos)
	
	for n in saved_tiles_array:
		if n.position == cellposition:
			set_tile(n.position, n.ID)
			area.delete_self()
