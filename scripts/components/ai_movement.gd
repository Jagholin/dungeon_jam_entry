class_name AIMovementComponent
extends GridMovementComponent

const AI_COMPONENT_NAME := &"AIMovementComponent"

func get_component_name() -> StringName:
	return AI_COMPONENT_NAME

func get_component_names() -> Array[StringName]:
	var temp := super.get_component_names()
	temp.push_back(AI_COMPONENT_NAME)
	return temp

## Describes if the target should pathfind to the player or to some point on the same x or z axis
@export var is_an_archer: bool = false
@export var archer_range: int = 10
@export var max_pathfind_distance: int = 100

var path_cache: Array[Vector3i]
var path_goal: Vector3i = Vector3i(-1000, -1000, -1000)

func _possibleDirections(_from: Vector3i) -> Array[Vector3i]:
	return [Vector3i(1, 0, 0), Vector3i(0, 0, 1), Vector3i(-1, 0, 0), Vector3i(0, 0, -1)]

class LocationValue:
	var loc: Vector3i
	var value: int
	var start_distance: int
	var previous_location: LocationValue = null

	static func from_point(p: Vector3i, nvalue: int = -1, start_disctance: int = 0) -> LocationValue:
		var temp := LocationValue.new()
		temp.loc = p
		temp.value = nvalue
		temp.start_distance = start_disctance
		return temp

func _pathfindDistance(from: Vector3i, to: Vector3i) -> int:
	var temp := from - to
	return absi(temp.x) + absi(temp.z)

func _pathfindTo(pos: Array[Vector3i], obstaclePred: Callable, maxDistance: int = 1000000) -> Array[Vector3i]:
	var candidatePoints: Array[LocationValue] = []
	candidatePoints.assign(pos.map(func(p): return LocationValue.from_point(p, _pathfindDistance(p, grid_coordinate))))
	candidatePoints.sort_custom(func(a, b): return a.value + a.start_distance < b.value + b.start_distance)
	var passedPoints: Array[LocationValue] = candidatePoints.duplicate()
	var endLocation: LocationValue
	var pathFound = false
	while not pathFound:
		if candidatePoints.is_empty():
			break
		var currentPoint := candidatePoints.pop_front() as LocationValue
		var nextStartDistance := currentPoint.start_distance + 1
		if nextStartDistance >= maxDistance:
			continue
		for dir in _possibleDirections(currentPoint.loc):
			var nextCandidate := currentPoint.loc + dir
			var nextValue := _pathfindDistance(nextCandidate, grid_coordinate)
			var previousEnc := passedPoints.filter(func(e): return e.loc == nextCandidate)
			if not previousEnc.is_empty():
				# we were here before so skip
				continue
			if obstaclePred.call(nextCandidate):
				continue
			var newLocValue := LocationValue.from_point(nextCandidate, nextValue, nextStartDistance)
			newLocValue.previous_location = currentPoint
			passedPoints.push_back(newLocValue)
			if nextCandidate == grid_coordinate:
				pathFound = true
				endLocation = newLocValue
			
			var insPosition := candidatePoints.bsearch_custom(newLocValue, func(a, b): 
				return a.value + a.start_distance < b.value + b.start_distance, true)
			candidatePoints.insert(insPosition, newLocValue)
	
	if pathFound:
		var result: Array[Vector3i] = []
		endLocation = endLocation.previous_location
		while endLocation:
			result.push_back(endLocation.loc)
			endLocation = endLocation.previous_location
		return result
			
	return []

enum {POSITION_REACHED, NO_PATH, MOVING}
## returns one of the POSITION_REACHED, NO_PATH, MOVING
func move_to(pos: Vector3i) -> int:
	if pos != path_goal:
		var pathGoals: Array[Vector3i] = [pos]
		if is_an_archer:
			for i in range(1, archer_range):
				pathGoals.push_back(Vector3i(pos.x + i, pos.y, pos.z))
				pathGoals.push_back(Vector3i(pos.x - i, pos.y, pos.z))
				pathGoals.push_back(Vector3i(pos.x, pos.y, pos.z + i))
				pathGoals.push_back(Vector3i(pos.x, pos.y, pos.z - i))
		# filter out all walls and nonexisiting cells
		pathGoals = pathGoals.filter(func(p: Vector3i): 
			return Globals.get_current_level().location_exists(p) and not Globals.get_current_level().is_a_wall(p) and not Obstacles.is_an_obstacle(p))
		path_cache = _pathfindTo(pathGoals, func(p: Vector3i): 
			return Obstacles.is_an_obstacle(p) or Globals.get_current_level().is_a_wall(p), max_pathfind_distance)
		path_goal = pos
	#print("Current path is ", path_cache)
	if grid_coordinate == pos:
		return POSITION_REACHED
	if path_cache.is_empty():
		return NO_PATH
	var next_cell := path_cache[0] as Vector3i

	if grid_direction + grid_coordinate == next_cell:
		# move me forward
		move_forward()
		path_cache.pop_front()
	elif grid_coordinate - grid_direction == next_cell:
		# do 180
		rotate_left()
	elif grid_coordinate + Vector3i(grid_direction.z, 0, grid_direction.x) == next_cell:
		rotate_left()
	elif grid_coordinate + Vector3i(grid_direction.z, 0, grid_direction.x) == next_cell:
		rotate_right()
	else:
		push_error("This cant happen lol")

	return MOVING

## returns one of the POSITION_REACHED, NO_PATH, MOVING
func approach(pos: Vector3i) -> int:
	var pathGoals: Array[Vector3i] = [pos]
	if is_an_archer:
		for i in range(1, archer_range):
			pathGoals.push_back(Vector3i(pos.x + i, pos.y, pos.z))
			pathGoals.push_back(Vector3i(pos.x - i, pos.y, pos.z))
			pathGoals.push_back(Vector3i(pos.x, pos.y, pos.z + i))
			pathGoals.push_back(Vector3i(pos.x, pos.y, pos.z - i))
	# filter out all walls and nonexisiting cells
	pathGoals = pathGoals.filter(func(p: Vector3i): 
		return Globals.get_current_level().location_exists(p) and not Globals.get_current_level().is_a_wall(p) and not Obstacles.is_an_obstacle(p))

	if pos != path_goal:
		path_cache = _pathfindTo(pathGoals, func(p: Vector3i): 
			return Obstacles.is_an_obstacle(p) or Globals.get_current_level().is_a_wall(p), max_pathfind_distance)
		path_goal = pos

	#print("Current path is ", path_cache)
	if path_cache.is_empty():
		return NO_PATH
	var next_cell := path_cache[0] as Vector3i

	if next_cell == pos and grid_direction + grid_coordinate == next_cell:
		return POSITION_REACHED

	if grid_direction + grid_coordinate == next_cell:
		# move me forward
		move_forward()
		path_cache.pop_front()
	elif grid_coordinate - grid_direction == next_cell:
		# do 180
		#print("180 - rotating left")
		rotate_left()
	elif grid_coordinate + Vector3i(grid_direction.z, 0, -grid_direction.x) == next_cell:
		#print("rotating left")
		rotate_left()
	elif grid_coordinate + Vector3i(-grid_direction.z, 0, grid_direction.x) == next_cell:
		#print("rotating right")
		rotate_right()
	else:
		push_error("This cant happen lol")

	return MOVING
