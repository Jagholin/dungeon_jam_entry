## Currently available scene objects:
1. buttons.tscn - wall mounted button that has a number from 0 to 9. The value of a button can be set in its properties.
2. enemy.tscn - a simple enemy(model pending). Has AI that allows it to move around the room. Can't move through doors
3. key_*.tscn - a key. Is identified by its name(see the Inspector tab). Can only be picked up from when standing on the tile directly in front of it
4. lever_*.tscn - is a lever.
5. marker3d.tscn - 3d marker that points in what's considered to be "forward" direction. Invisible in-game
6. obstacle_marker.tscn - 3d marker that designates the tile it is in as a static obstacle for the player. Useful for placing it where there are
decoratives that should be considered, well, an obstacle. Also invisible in-game
7. player_trigger.tscn - emits a signal when the player moves into the tile where the trigger is placed.
8. teleporter.tscn - can be used to teleport the player to its location. Has `activate()` function that does the job.

logic_traps.tscn - implements logic for levers and traps puzzle. Supports 4 switches(levers) that control an array of traps(trapdoors). Which switches act on which traps can be set with `switch actions 0-3` properties. Traps and switch actions arrays should have the same size. The solution and switches properties also should have the same size. The solution property contains the intended solution to the puzzle.

simon_says.tscn - logic for the simon says puzzle. Overview camera is a Camera3D object positioned at some point where it can see all the buttons. Buttons is an array of size 10 which has references to buttons.tscn instances. This array can contain nulls if the button for the value doesn't exist.

## Keys and doors:
A door that is opened with a key must have both `opens when clicked` and `needs key to unlock` properties set to `true`. Key has a `item name` property which is used to identify any particular key and will be shown in HUD when the key is picked up. If a door is opened by a key named 'my_key', it must have its 'key name' property set accordingly. 


## Other useful stuff:
to get player object: `Globals.get_character_controller()`
to get the level object: `Globals.get_current_level()`
health is in Stats.health and Stats.max_health

to get coordinate of something you need to get reference to the GridBound component. For the player, this can be done with
`var gb := player.get_component(GridBoundComponent.GB_COMPONENT_NAME) as GridBoundComponent`
and then the coordinate will be in `gb.grid_coordinate`