extends Node

var obstacles: Array[Vector3i]
var static_obstacles: Array[Vector3i]

func register_obstacle(obs: Vector3i):
	#print("register obstacle at, ", obs)
	obstacles.push_back(obs)

func register_static_obstacle(obs: Vector3i):
	print("adding static obs: ", obs)
	static_obstacles.push_back(obs)

func unregister_obstacle(obs: Vector3i):
	#print("unregister obstacle at, ", obs)
	obstacles.erase(obs)
	static_obstacles.erase(obs)

func is_an_obstacle(q: Vector3i) -> bool:
	return (q in obstacles) or (q in static_obstacles)

func is_static_obstacle(q: Vector3i) -> bool:
	return q in static_obstacles

func force_clear():
	obstacles.clear()
	static_obstacles.clear()
