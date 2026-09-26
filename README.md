# Gravity well

A game created for [1-bit jam 14](https://itch.io/jam/1-bit-jam-14) in 1 week. The game can be played, and builds downloaded from [here](https://tyrannicodin.itch.io/gravity-well).
Created using godot 4.7.

Font used: Pixel Operator

Models created in Blender.

### Level select scene: game/loader/picker.tscn
The level select scene gets an array of levels in order from the LevelManager autoload (game/loader/level_mananger.gd). Then, a button is created for each level which loads the game scene asynchronously to prevent freezing.


### Game scene: game/loader/picker.tscn
On ready, the game scene uses the current_level from LevelManager and loads the scene from the LevelInfo resource. This causes a delay in loading which could be improved by adding a loading screen that is hidden once the level is loaded.
The game scene contains the shader viewport, which holds the 3d scene and converts the multi-coloured scene to a dithered 1-bit image. The shader can be bypassed in the subviewportContainers shader properties. The pause screen is a seperate subviewportContainer with a more simple shader that simply maps to one of the two colors and removes alpha.

### Saving data
Data is saved to the `user://` directory via the ConfigManager autoload. This includes both config and progress. Progress is stored as two arrays, one containing level unlocks and the other completions. Each LevelInfo resource contains details about it's initial unlock state, what other levels it unlocks and if it is a challenge levels. Challenge levels are unlocked once all non-challenge levels are completed.
