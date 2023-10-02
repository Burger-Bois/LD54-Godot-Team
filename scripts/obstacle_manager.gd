extends Node2D
class_name ObstacleManager

signal carrying_obstacle_changed(value: bool)

const OBSTACLE_TILE_ID := 3
const OBSTACLE_VALID_PLACEMENTS := [1]

@export var tilemap: TileMap
@export var interactableArea: PackedScene

var saved_tiles_array = []
var carrying_obstacle = false:
	set(value):
		carrying_obstacle_changed.emit(value)
		carrying_obstacle = value

var _obstacle_area_map := {} as Dictionary # Dictionary[Vectori, InteractableArea]

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		var clicked_tile_coords := tilemap.local_to_map(get_local_mouse_position())
		var clicked_tile_id := tilemap.get_cell_source_id(0, clicked_tile_coords)
		
		if carrying_obstacle and OBSTACLE_VALID_PLACEMENTS.has(clicked_tile_id):
			set_and_save_tile(clicked_tile_coords, OBSTACLE_TILE_ID, clicked_tile_id)
			carrying_obstacle = false
		
		elif clicked_tile_id == OBSTACLE_TILE_ID:
			var obstacle_area := _obstacle_area_map[clicked_tile_coords] as InteractableArea
			if obstacle_area.action_state == "interactable":
				interact_with_tile(obstacle_area)
	
##set tile method that takes in the position and what the tile was
#save that to an array of tile datas
func set_and_save_tile(pos: Vector2i, new_tile_ID: int, old_tile_ID: int):
	set_tile(pos, new_tile_ID)
	
	var savedtile = SavedTileData.new(pos, old_tile_ID)
	saved_tiles_array.push_back(savedtile)
	
	var new_area = interactableArea.instantiate() as InteractableArea
	new_area.obstacle_manager = self
	new_area.global_position = tilemap.map_to_local(pos)
	_obstacle_area_map[pos] = new_area
	call_deferred("add_child", new_area)
	
func set_tile(pos: Vector2i, new_tile_ID: int):
	tilemap.set_cell(0, pos, new_tile_ID, Vector2i(0,0))

##restoresavedtile method that takes in position and returns the tile to its original form
func interact_with_tile(area: InteractableArea):
	if carrying_obstacle:
		return 
	else:
		carrying_obstacle = true
	
	##set tile at pos to old tile
	var cellposition = tilemap.local_to_map(area.global_position)
	
	for n in saved_tiles_array:
		if n.position == cellposition:
			set_tile(n.position, n.ID)
			area.delete_self()
			_obstacle_area_map.erase(_obstacle_area_map.find_key(area))
