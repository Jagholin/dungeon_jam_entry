# Order of initialisation

1. The scenes and their children are created and added to the scene graph. All
   \_ready() functions are run. This means that the GridMap and its contents
   exist and their positions are well defined.
2. The GridCoordinates system is initialised. All components now have access to
   the locations and orientations of all controlled entities.
3. <removed>
4. All other systems are initialized.

